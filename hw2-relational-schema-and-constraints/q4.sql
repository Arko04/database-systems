CREATE TABLE Manager_Control(
    manager_id INTEGER, 
    contact_info CHAR(20),
    customer_id INTEGER,
    loan_number INTEGER,
    PRIMARY KEY(manager_id),
    FOREIGN KEY(customer_id, loan_number) REFERENCES Aggregation ON DELETE NO ACTION
);

CREATE TABLE Aggregation(
    customer_id INTEGER,
    loan_number INTEGER,
    PRIMARY KEY(customer_id, loan_number),
    FOREIGN KEY(customer_id, loan_number) REFERENCES gets ON DELETE NO ACTION,
    FOREIGN KEY(loan_number) REFERENCES Loan ON DELETE NO ACTION 
);

CREATE TABLE Loan( -- Loan + Requires guarantor
    loan_number INTEGER,
    amount INTEGER,
    customer_id INTEGER NOT NULL,
    PRIMARY KEY(loan_number),
    FOREIGN KEY(customer_id) REFERENCES Customer ON DELETE NO ACTION
);

CREATE TABLE Loan_Payment(
    payment_id INTEGER,
    payment_date DATE, 
    amount REAL,
    loan_number INTEGER,
    PRIMARY KEY(loan_number, payment_id),
    FOREIGN KEY(loan_number) REFERENCES Loan ON DELETE CASCADE
);

CREATE TABLE Customer(
    customer_id INTEGER,
    custumer_city CHAR(20),
    customer_name CHAR(20),
    age INTEGER,
    PRIMARY KEY(customer_id)
);

CREATE TABLE gets(
    customer_id INTEGER,
    loan_number INTEGER,
    PRIMARY KEY(customer_id, loan_number),
    FOREIGN KEY(customer_id) REFERENCES Customer ON DELETE NO ACTION,
    FOREIGN KEY(loan_number) REFERENCES Loan ON DELETE NO ACTION
);

CREATE TABLE accounts(
    account_number INTEGER,
    balance INTEGER,
    customer_id INTEGER NOT NULL,
    PRIMARY KEY(account_number),
    FOREIGN KEY(customer_id) REFERENCES Customer ON DELETE NO ACTION
);

CREATE TABLE saving_accounts(
    account_number INTEGER,
    interest_rate REAL,
    PRIMARY KEY(account_number),
    FOREIGN KEY(account_number) REFERENCES accounts ON DELETE CASCADE
);

CREATE TABLE checking_amount(
    account_number INTEGER,
    PRIMARY KEY(account_number),
    FOREIGN KEY(account_number) REFERENCES accounts ON DELETE CASCADE
);
