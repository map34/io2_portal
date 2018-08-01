from gevent import monkey; monkey.patch_all()
from config import huey
from tasks import data_harvest, make_dates

import calendar

from yodapy.datasources import OOI

if __name__ == '__main__':
    # -- Data harvest Task --
    inst = input('Instrument: ')
    year = int(input('Year: '))
    month = int(input('Month: '))
    req = (inst, year, month)

    dates = make_dates(req)
    for date in dates:
        fask = data_harvest.s(inst, date)
        print(fask)
        huey.enqueue(fask)

    print(f'Enqueued {req}')

