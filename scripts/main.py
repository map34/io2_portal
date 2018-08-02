from gevent import monkey; monkey.patch_all()
from config import huey
from tasks import data_harvest, make_dates
import dill

import calendar

from yodapy.datasources import OOI

if __name__ == '__main__':
    # -- Data harvest Task --
    inst = input('Instrument: ')
    year = int(input('Year: '))
    month = int(input('Month: '))
    req = (inst, year, month)

    ooi = OOI()
    ooi.search('cabled', 'slope base', 'shallow profiler', inst)
    pickled_ooi = dill.dumps(ooi)

    dates = make_dates(req)
    for date in dates:
        fask = data_harvest.s(inst, date, pickled_ooi)
        print(fask)
        huey.enqueue(fask)

    print(f'Enqueued {req}')

