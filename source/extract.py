import openpyxl
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, BigInteger, String, Float, DateTime
from sqlalchemy.dialects.postgresql import VARCHAR, TIMESTAMP, NUMERIC
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.sql import insert

device_xlsx = 'device.xlsx'
store_xlsx = 'store.xlsx'
transactions_xlsx = 'transaction.xlsx'

engine = create_engine('postgresql://postgres:postgres@localhost:5432/giedrius')
metadata = MetaData(schema='sumup')

device_table = Table(
    'staging_device', metadata,
    Column('id', BigInteger),
    Column('type', Integer),
    Column('store_id', Integer)
)

store_table = Table(
    'staging_store', metadata,
    Column('id', Integer),
    Column('name', VARCHAR(255)),
    Column('address', VARCHAR(255)),
    Column('city', VARCHAR(100)),
    Column('country', VARCHAR(100)),
    Column('created_at', TIMESTAMP),
    Column('typology', VARCHAR(50)),
    Column('customer_id', Integer)
)

transactions_table = Table(
    'staging_transactions', metadata,
    Column('id', BigInteger),
    Column('device_id', BigInteger),
    Column('product_name', VARCHAR(255)),
    Column('product_sku', VARCHAR(100)),
    Column('category_name', VARCHAR(100)),
    Column('amount', NUMERIC(10, 2)),
    Column('status', VARCHAR(50)),
    Column('card_number', VARCHAR(50)),
    Column('cvv', VARCHAR(4)),
    Column('created_at', TIMESTAMP),
    Column('happened_at', TIMESTAMP)
)

metadata.create_all(engine)


def load_excel_to_db(excel_file, table_name, engine, metadata):
    wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
    sheet = wb.active
    headers = [cell.value for cell in sheet[1]]
    table = Table(table_name, metadata, autoload_with=engine)

    with engine.connect() as conn:
        for row in sheet.iter_rows(min_row=2, values_only=True):
            row_data = dict(zip(headers, row))

            if 'cvv' in row_data and row_data['cvv']:
                row_data['cvv'] = str(int(row_data['cvv']))

            if 'product_sku' in row_data and row_data['product_sku']:
                if isinstance(row_data['product_sku'], float):
                    row_data['product_sku'] = str(int(row_data['product_sku']))
                else:
                    row_data['product_sku'] = str(row_data['product_sku'])

            if 'card_number' in row_data and row_data['card_number']:
                if isinstance(row_data['card_number'], float):
                    row_data['card_number'] = str(int(row_data['card_number']))
                else:
                    row_data['card_number'] = str(row_data['card_number'])

            try:
                stmt = insert(table).values(row_data)
                conn.execute(stmt)
                conn.commit()
            except SQLAlchemyError as e:
                print(f"Error inserting row {row_data}: {str(e)}")


load_excel_to_db(device_xlsx, 'staging_device', engine, metadata)
load_excel_to_db(store_xlsx, 'staging_store', engine, metadata)
load_excel_to_db(transactions_xlsx, 'staging_transactions', engine, metadata)

print("Data loaded successfully into staging tables!")
