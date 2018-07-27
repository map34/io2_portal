from gevent import monkey; monkey.patch_all()
from config import huey
from tasks import data_harvest

import calendar

from yodapy.datasources import OOI

if __name__ == '__main__':
    # -- Data harvest Task --
    inst = input('Instrument: ')
    year = int(input('Year: '))
    month = int(input('Month: '))
    req = (inst, year, month)
    data_harvest(req)
    print(f'Enqueued {req}')
