CREATE TABLE Player(
    pid INTEGER,
    pname CHAR(20),
    pstart_date DATE,
    PRIMARY KEY(pid)
);

CREATE TABLE Premium(
    pid INTEGER,
    subscription CHAR(20),
    PRIMARY KEY(pid),
    FOREIGN KEY(pid) REFERENCES Player ON DELETE CASCADE
);

CREATE TABLE Free(
    pid INTEGER,
    PRIMARY KEY(pid),
    FOREIGN KEY(pid) REFERENCES Player ON DELETE CASCADE
);

CREATE TABLE Playground( -- Playground + makes
    pgid INTEGER,
    pgname CHAR(20),
    production_date DATE,
    best_record CHAR(20),
    pid INTEGER NOT NULL,
    PRIMARY KEY(pgid),
    FOREIGN KEY(pid) REFERENCES Premium ON DELETE NO ACTION
);

CREATE TABLE Tournament( -- Tournament + wins
    tid INTEGER,
    hold_date DATE,
    pid INTEGER,
    PRIMARY KEY(tid),
    FOREIGN KEY(pid) REFERENCES Player ON DELETE NO ACTION
);

CREATE TABLE RecordDate(
    begin_date DATE,
    record_time TIME,
    PRIMARY KEY(begin_date, record_time)
);

CREATE TABLE Play(
    begin_date DATE,
    record_time TIME,
    pgid INTEGER,
    pid INTEGER,
    PRIMARY KEY(begin_date, record_time, pgid, pid),
    FOREIGN KEY(begin_date, record_time) REFERENCES RecordDate ON DELETE NO ACTION,
    FOREIGN KEY(pgid) REFERENCES Playground ON DELETE NO ACTION,
    FOREIGN KEY(pid) REFERENCES Player ON DELETE NO ACTION 
);

CREATE TABLE Comment( -- Comment + sends
    cid INTEGER,
    comment CHAR(100),
    pid INTEGER,
    pgid INTEGER,
    PRIMARY KEY(cid, pid, pgid),
    FOREIGN KEY(pid) REFERENCES Player ON DELETE CASCADE,
    FOREIGN KEY(pgid) REFERENCES Playground ON DELETE CASCADE
);

