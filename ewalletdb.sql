CREATE Table users(
	id int PRIMARY KEY,
	nama varchar NOT NULL,
	username varchar(15) UNIQUE NOT NULL,
	email varchar UNIQUE, 
	password varchar NOT NULL,
	avatar varchar,
	phone_no varchar NOT NULL
)

INSERT INTO users(id, nama, username, email, password, avatar, phone_no) VALUES(
1, 'adios', 'adiosdios', 'adios@gmail.com', 'password', '', '08312321831')

SELECT * FROM users;

INSERT INTO users(id, nama, username, email, password, avatar, phone_no) VALUES
(2, 'didis', 'didis', 'didis@gmail.com', 'password', '', '08312321831'),
(3, 'disa', 'disa', 'disa@gmail.com', 'password', '', '08312321831');

SELECT * FROM users;

CREATE Table users(
	id SERIAL PRIMARY KEY,
	nama varchar NOT NULL,
	username varchar(15) UNIQUE NOT NULL,
	email varchar UNIQUE, 
	password varchar NOT NULL,
	avatar varchar,
	phone_no varchar NOT NULL
)

INSERT INTO users(nama, username, email, password, phone_no) VALUES
('adios', 'adiosdios', 'adios@gmail.com', 'password', '08312321831'),
('didis', 'didis', 'didis@gmail.com', 'password', '08312321831'),
('disa', 'disa', 'disa@gmail.com', 'password', '08312321831');

SELECT * FROM users;

UPDATE users SET username = 'didiss' WHERE username = 'didis';

CREATE Table transaction(
	id SERIAL PRIMARY KEY,
	amount varchar NOT NULL,
	datetime timestamptz,
	transaction_no varchar UNIQUE NOT NULL, 
	status varchar NOT NULL,
	sender_id int REFERENCES users(id),
	recepient_id int REFERENCES users(id)
);

SELECT * FROM transaction;

ALTER TABLE transaction
ADD description varchar;

INSERT INTO transaction(amount, datetime, transaction_no, status, sender_id, recepient_id, description) VALUES
('15000', NOW(), '1234568379', 'sent', 1, 2, 'bakso'),
('30000', NOW(), '1234568374', 'sent', 2, 1, 'cilok'),
('45000', NOW(), '1234568375', 'sent', 2, 3, 'cilor'),
('15000', NOW(), '1234568376', 'sent', 3, 2, 'takoyaki'),
('20000', NOW(), '1234568377', 'sent', 1, 3, 'bubur'),
('13000', NOW(), '1234568378', 'sent', 3, 1, 'ayam goreng');

ALTER TABLE transaction
ADD type varchar;

INSERT INTO transaction(amount, datetime, transaction_no, status, sender_id, recepient_id, description, type) VALUES
('15000', NOW(), '1234568380', 'sent', 1, 2, 'bakso', 'Transfer'),
('30000', NOW(), '1234568381', 'sent', 2, 1, 'cilok', 'Transfer'),
('45000', NOW(), '1234568382', 'sent', 2, 3, 'cilor', 'Transfer'),
('15000', NOW(), '1234568383', 'sent', 3, 2, 'takoyaki', 'Transfer'),
('20000', NOW(), '1234568384', 'sent', 1, 3, 'bubur', 'Transfer'),
('13000', NOW(), '1234568385', 'sent', 3, 1, 'ayam goreng', 'Transfer');

SELECT transaction.datetime, transaction.type, 
case when transaction.type = 'Transfer' AND transaction.sender_id = 1 then users.nama
when transaction.type = 'Transfer' AND transaction.recepient_id = 1 then (SELECT users.nama FROM users where id = transaction.sender_id)
when transaction.type = 'Top Up' AND transaction.sender_id = 1 OR transaction.recepient_id = 1 then ''
end as fromandto,
transaction.description, 
case when transaction.sender_id = 1 then CONCAT('-', transaction.amount)
when transaction.recepient_id = 1 then CONCAT('+', transaction.amount)
end as amount
from users
inner join transaction on users.id = transaction.recepient_id
where transaction.sender_id = 1 OR transaction.recepient_id = 1;

INSERT INTO transaction(amount, datetime, transaction_no, status, sender_id, description, type) VALUES
('15000', NOW(), '1234568390', 'sent', 1, 'Top up from Bank Transfer', 'Top up'),
('30000', NOW(), '1234568391', 'sent', 1, 'Top up from Bank Transfer', 'Top up'),
('20000', NOW(), '1234568392', 'sent', 1, 'Top up from Bank Transfer', 'Top up'),
('13000', NOW(), '1234568393', 'sent', 1, 'Top up from Bank Transfer', 'Top up');

DELETE FROM transaction Where type is null;