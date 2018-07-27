from config import huey
from ooi_harvest import get_data

from huey import crontab

import logging

import calendar
import gevent
import datetime

from yodapy.datasources import OOI


@huey.task()
def data_harvest(req):
    inst, year, month = req
    ooi = OOI()
    ooi.search('cabled', 'slope base', 'shallow profiler', inst)
    cal = calendar.Calendar()
    print(ooi.view_instruments())

    days = [d for d in cal.itermonthdays(year, month)]
    dates = [i for i in cal.itermonthdates(year, month)]
    all_dates = list(map(lambda x: x[1], filter(lambda x: x[0] != 0, zip(days, dates))))
    # -- month_dates broken by 5 day chunks
    month_dates_break = [all_dates[i:i + 5] for i in range(0, len(all_dates), 5)]

    for month_dates in month_dates_break:
        start_end = [(d, month_dates[i+1]) for i, d in enumerate(month_dates) if i < len(month_dates) - 1]
        jobs = [gevent.spawn(get_data, url, ooi) for url in start_end[:5]]
        gevent.joinall(jobs, timeout=700)

        print([job.value for job in jobs])


# @huey.periodic_task(crontab(minute='*'))
# def print_time():
#     logger = logging.getLogger('timer')
#     logger.info(datetime.datetime.now().isoformat())
