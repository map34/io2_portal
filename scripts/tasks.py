from config import huey
from ooi_harvest import get_data

from huey import crontab

import logging
import dill

import calendar
import gevent
import datetime

from yodapy.datasources import OOI

logger = logging.getLogger(__name__)


def make_dates(req, chunk=5):
    inst, year, month = req
    cal = calendar.Calendar()

    days = [d for d in cal.itermonthdays(year, month)]
    dates = [i for i in cal.itermonthdates(year, month)]
    all_dates = list(map(lambda x: x[1], filter(lambda x: x[0] != 0, zip(days, dates))))
    # -- month_dates broken by 5 day chunks
    return [all_dates[i:i + chunk + 1] for i in range(0, len(all_dates), chunk)]


@huey.task(retries=5, retry_delay=10)
def data_each_harvest(inst, url, ooi):
    real_ooi = dill.loads(ooi)
    logging.info(f'URL: {url}')
    logging.info(f'Inst: {inst}')
    logging.info(f'OOI: {real_ooi._client}')
    try:
        task = get_data(url, real_ooi)
        if task is None:
            raise Exception(f'Task {url}: failed')
    except Exception as e:
        raise e


@huey.task()
def data_harvest(inst, month_dates, ooi):
    # Bug: Dates do not have multiple of 5s. For example:
    # [
    #   (datetime.date(2017, 9, 21), datetime.date(2017, 9, 22)),
    #   (datetime.date(2017, 9, 22), datetime.date(2017, 9, 23)),
    #   (datetime.date(2017, 9, 23), datetime.date(2017, 9, 24)),
    #   (datetime.date(2017, 9, 24), datetime.date(2017, 9, 25))
    ##  You need 25-26
    # ]

    start_end = [(d, month_dates[i+1]) for i, d in enumerate(month_dates) if i < len(month_dates) - 1]
    logger.info(start_end)

    [data_each_harvest(inst, date, ooi) for date in start_end]
