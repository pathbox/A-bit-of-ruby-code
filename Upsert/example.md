##### 该操作的实现原理是通过判断插入的记录里是否存在主键冲突来决定是插入还是更新，当出现主键冲突时则进行更新操作（使用 ON DUPLICATE KEY UPDATE 语句后面的参数），若无冲突则进行插入操作

MySQL 有 INSERT... ON DUPLICATE KEY UPDATE语法

```
INSERT INTO customers (id, first_name, last_name, email) VALUES (30797, 'hooopo1', 'wang', 'hoooopo@gmail.com')
ON DUPLICATE KEY UPDATE
first_name = VALUES(first_name), last_name = VALUES(last_name)
```

PostgreSQL 从 9.5 也有了INSERT ... ON CONFLICT UPDATE语法，效果和 MySQL 类似：

```
INSERT INTO customers (id, first_name, last_name, email) VALUES (30797, 'hooopo1', 'wang', 'hoooopo@gmail.com') 
ON CONFLICT(id) DO  UPDATE 
SET first_name = EXCLUDED.first_name, last_name = EXCLUDED.last_name;
```

bulk insert 支持 REPLACE, 批量插入的同时还可以upsert
```
LOAD DATA LOCAL INFILE '/Users/hooopo/data/out/product_sales_facts.txt'
REPLACE INTO TABLE product_sale_facts FIELDS TERMINATED BY ',' (`id`,`date_id`,`order_id`,`product_id`,`address_id`,`unit_price`,`purchase_price`,`gross_profit`,`quantity`,`channel_id`,`gift`)
```

