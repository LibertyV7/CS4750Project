CREATE TABLE IF NOT EXISTS Member (
    computingID VARCHAR(6) PRIMARY KEY NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    memType VARCHAR(10),
    provieSemester VARCHAR(50) NOT NULL,
    duesPaid BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ProvisionalMember (
    provID INT AUTO_INCREMENT PRIMARY KEY,
    computingID VARCHAR(6) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (computingID) REFERENCES Member(computingID)
);

CREATE TABLE IF NOT EXISTS Officers(
    officerID INT AUTO_INCREMENT PRIMARY KEY,
    computingID VARCHAR(6) NOT NULL,
    position VARCHAR(50),
    FOREIGN KEY (computingID) REFERENCES Member(computingID)
);

CREATE TABLE IF NOT EXISTS ProvieRequirements (
    requirementID INT AUTO_INCREMENT PRIMARY KEY,
    provID INT,
    completed BOOLEAN NOT NULL DEFAULT 0,
    attendance BOOLEAN NOT NULL DEFAULT 0,
    fullMeeting BOOLEAN NOT NULL DEFAULT 0,
    historyTour BOOLEAN NOT NULL DEFAULT 0,
    majorService BOOLEAN NOT NULL DEFAULT 0,
    minorService BOOLEAN NOT NULL DEFAULT 0,
    debate BOOLEAN NOT NULL DEFAULT 0,
    literaryPresentation BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (provID) REFERENCES ProvisionalMember(provID)
);

CREATE TABLE IF NOT EXISTS Debate (
    debateID INT AUTO_INCREMENT PRIMARY KEY,
    debateDate DATE NOT NULL,
    resolution VARCHAR(100) NOT NULL,
    debateType VARCHAR(10) NOT NULL,
    qualityGovernment INT,
    qualityOpposition INT,
    sentimentGovernment INT,
    sentimentOpposition INT,
    qualityOverall VARCHAR(10),
    sentimentOverall VARCHAR(10),
    CONSTRAINT chk_debateType CHECK (debateType IN ('Humorous', 'Serious')),
    CONSTRAINT chk_qualityOverall CHECK (qualityOverall IN ('Government',
																												    'Opposition')),
    CONSTRAINT chk_sentimentOverall CHECK (sentimentOverall IN ('In Favor',
																														   'Against'))
);

CREATE TABLE IF NOT EXISTS HumorousDebate (
    debateID INT PRIMARY KEY,
    computingID_gov1 VARCHAR(6),
    computingID_gov2 VARCHAR(6),
    computingID_gov3 VARCHAR(6),
    computingID_opp1 VARCHAR(6),
    computingID_opp2 VARCHAR(6),
    computingID_opp3 VARCHAR(6),
    FOREIGN KEY (debateID) REFERENCES Debate(debateID),
    FOREIGN KEY (computingID_gov1) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_gov2) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_gov3) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_opp1) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_opp2) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_opp3) REFERENCES Member(computingID)
);

CREATE TABLE IF NOT EXISTS SeriousDebate (
    debateID INT PRIMARY KEY,
    computingID_minister_of_government VARCHAR(6),
    computingID_member_of_government VARCHAR(6),
    computingID_leader_of_opposition VARCHAR(6),
    computingID_member_of_opposition VARCHAR(6),
    FOREIGN KEY (debateID) REFERENCES Debate(debateID),
    FOREIGN KEY (computingID_minister_of_government) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_member_of_government) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_leader_of_opposition) REFERENCES Member(computingID),
    FOREIGN KEY (computingID_member_of_opposition) REFERENCES Member(computingID)
);

CREATE TABLE IF NOT EXISTS LiteraryPresentation (
    literaryPresentationID INT AUTO_INCREMENT PRIMARY KEY,
    presentationDate DATE NOT NULL,
    computingID INT NOT NULL,
    title VARCHAR(255),
    author VARCHAR(50),
    FOREIGN KEY (computingID) REFERENCES Member(computingID)
);

CREATE TABLE IF NOT EXISTS MemberHumorousDebate (
    computingID INT NOT NULL,
    debateID INT NOT NULL,
    PRIMARY KEY (computingID, debateID),
    FOREIGN KEY (computingID) REFERENCES Member(computingID),
    FOREIGN KEY (debateID) REFERENCES HumorousDebate(debateID)
);

CREATE TABLE IF NOT EXISTS MemberSeriousDebate (
    computingID INT,
    debateID INT,
    PRIMARY KEY (computingID, debateID),
    FOREIGN KEY (computingID) REFERENCES Member(computingID),
    FOREIGN KEY (debateID) REFERENCES SeriousDebate(debateID)
);

INSERT INTO Member (computingID, firstName, lastName, provieSemester)
VALUES ('MGS4XM', 'Liberty', 'Vanty', 'Spring 2022');

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('SQM8UK', 'Seung', 'Lee', 'Fall 2023', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('RZR8DT', 'KC', 'Christman', 'Fall 2021', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('WQP5GV', 'Eli', 'Boone', 'Spring 2024', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester)
VALUES ('BVJ7KF', 'Daisy', 'Wong', 'Spring 2024');

INSERT INTO Member (computingID, firstName, lastName, provieSemester)
VALUES ('HFR9NQ', 'Lucas', 'Piette', 'Spring 2023');

INSERT INTO Member (computingID, firstName, lastName, provieSemester)
VALUES ('BNJ7PY', 'Sloane', 'Daly', 'Fall 2023');

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('LJN5YMS', 'Luke', 'Napolitano', 'Spring 2022', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('ZVC9MS', 'Stephanie', 'Rajab', 'Fall 2023', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('AND6BR', 'Susannah', 'Baker', 'Fall 2022', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('CAL6ER', 'Cassie', 'Lipton', 'Fall 2021', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('NYV5KN', 'Joe', 'Stern', 'Fall 2023', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester)
VALUES ('QWE9AU', 'Sofia', 'Rosato', 'Spring 2024');

INSERT INTO Member (computingID, firstName, lastName, provieSemester)
VALUES ('KXU7JF', 'Cameron', 'Penn', 'Spring 2024');

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('QFS9SY', 'Lara', 'Weinberg', 'Fall 2022', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('USZ2FM', 'Charles', 'Dorsey', 'Spring 2024', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('RNB6NJR', 'Ryan', 'Brady', 'Spring 2022', 1);

INSERT INTO Member (computingID, firstName, lastName, provieSemester, duesPaid)
VALUES ('MAD7HJA', 'Matthew', 'Docalovich', 'Spring 2021', 1);

INSERT INTO ProvisionalMember (computingID)
SELECT computingID
FROM Member
WHERE provieSemester = 'Spring 2024';

INSERT INTO Officers (computingID, position)
VALUES
    ('CAL6ER', 'President'),
    ('RZR8DT', 'Vice President'),
    ('NYV5KN', 'Secretary'),
    ('AND6BR', 'Treasurer'),
    ('ZVC9MS', 'Reporter'),
    ('LJN5YMS', 'Sargeant-at-Arms'),
    ('MGS4XM', 'Davis House Head'),
    ('HFR9NQ', 'Social Chair'),
    ('WQP5GV', 'Provie Chair');

INSERT INTO ProvieRequirements (provID)
SELECT provID
FROM ProvisionalMember;

INSERT INTO Debate (debateDate, resolution, debateType)
VALUES
	('2024-03-21', 'Resolved: The United States should prioritize trade with
	democracies.', 'Serious'),
	('2024-03-21', 'Resolved: All good things must come to an ends.',
	'Humorous'),
	('2024-02-27', 'Resolved: It’s so over.', 'Humorous'),
	('2024-02-27', 'Resolved:It is unethical to bring children
	into the world', 'Serious');

INSERT INTO Debate (debateDate, resolution, debateType, qualityGovernment,
qualityOpposition, sentimentGovernment, sentimentOpposition, qualityOverall,
sentimentOverall)
VALUES ('2024-02-06', 'Resolved: The United States should continue
to militarily support Ukraine.', 'Serious', 8, 7, 6, 8, 'Government', 'In Favor');

INSERT INTO HumorousDebate (debateID, computingID_gov1, computingID_gov2,
computingID_gov3, computingID_opp1, computingID_opp2, computingID_opp3)
VALUES
    (1, 'CAL6ER', 'NYV5KN', 'RNB6NJR', 'AND6BR', 'MGS4XM', 'HFR9NQ'),
    (2, 'QWE9AU', 'KXU7JF', 'HFR9NQ', 'RNB6NJR', 'NYV5KN', 'BNJ7PY');

INSERT INTO SeriousDebate (debateID, computingID_minister_of_government,
computingID_member_of_government, computingID_leader_of_opposition,
computingID_member_of_opposition)
VALUES
    (1, 'RNB6NJR', 'NYV5KN', 'CAL6ER', 'AND6BR'),
    (2, 'KXU7JF', 'RZR8DT', 'QWE9AU', 'AND6BR'),
    (3, 'BNJ7PY', 'ZVC9MS', 'MAD7HJA', 'SQM8UK');

INSERT INTO LiteraryPresentation (presentationDate, computingID, title, author)
VALUES
	('2024-03-21', 'SQM8UK', 'The Great Gatsby', 'F. Scott Fitzgerald'),
	('2024-02-27', 'QWE9AU', 'Excerpts from Three Body problem', 'Cin Lu'),
	('2024-03-21', 'KXU7JF', 'Original Poem', 'Cameron Penn'),
	('2024-02-27', 'BNJ7PY', 'Epic George Washington Retelling', 'PixieFR');
