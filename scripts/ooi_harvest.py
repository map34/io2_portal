"""ooi_harvest.py

Python Script for Harvesting NetCDF from OOI UFrame via M2M using yodapy.
"""
# coding: -*-utf-8-*-

import os

TEST_DIR = '/TESTS/'

__author__ = 'Landung Setiawan'
__version__ = '0.1.0a0'


def export_nc(dstest, begin):
    dstest.chunk(chunks={'time': 1000})
    if '_NCProperties' in dstest.attrs.keys():
        dstest.attrs.pop('_NCProperties')
    ncfile = os.path.join(TEST_DIR, '{}_{:%Y_%m_%d}.nc'.format(dstest.attrs['id'], begin))
    dstest.to_netcdf(ncfile)
    return ncfile


def get_data(dr, ooi):
    begin, end = dr
    ooi.request_data(begin_date=begin.isoformat(), end_date=end.isoformat())
    if ooi.raw():
        if 'status_code' in ooi.raw()[0].keys():
            return None
        print(ooi.raw())
        data_list = ooi.to_xarray()
        ncfile_list = []
        if data_list:
            for ds in data_list:
                ncfile = export_nc(ds, begin)
                ncfile_list.append(ncfile)
            return ncfile_list 
