CREATE TABLE IF NOT EXISTS Member (
    memberID INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    computingID VARCHAR(50) NOT NULL,
    provideSemester VARCHAR(50) NOT NULL,
    duesPaid BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ProvisionalMember (
    provID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT,
    completed BOOLEAN NOT NULL,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

CREATE TABLE IF NOT EXISTS Officers(
    officerID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT,
    position VARCHAR(50),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
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
    date INT NOT NULL,
    resolution VARCHAR(1000) NOT NULL,
    debateType VARCHAR(50) NOT NULL,
    qualityGovernment INT CHECK (qualityGovernment BETWEEN 0 AND 10),
    qualityOpposition INT CHECK (qualityOpposition BETWEEN 0 AND 10),
    sentimentGovernment INT CHECK (sentimentGovernment BETWEEN 0 AND 10),
    sentimentOpposition INT CHECK (sentimentOpposition BETWEEN 0 AND 10),
    qualityOverall DECIMAL(4,2) CHECK (qualityOverall BETWEEN 0 AND 10),
    sentimentOverall DECIMAL(4,2) CHECK (sentimentOverall BETWEEN 0 AND 10)
);

CREATE TABLE IF NOT EXISTS HumorousDebate (
    debateID INT AUTO_INCREMENT PRIMARY KEY,
    memberID_gov1 INT,
    memberID_gov2 INT,
    memberID_gov3 INT,
    memberID_opp1 INT,
    memberID_opp2 INT,
    memberID_opp3 INT,
    FOREIGN KEY (debateID) REFERENCES Debate(debateID),
    FOREIGN KEY (memberID_gov1) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_gov2) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_gov3) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_opp1) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_opp2) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_opp3) REFERENCES Member(memberID)
);

CREATE TABLE IF NOT EXISTS SeriousDebate (
    debateID INT AUTO_INCREMENT PRIMARY KEY,
    memberID_minister_of_government INT,
    memberID_member_of_government INT,
    memberID_leader_of_opposition INT,
    memberID_member_of_opposition INT,
    FOREIGN KEY (debateID) REFERENCES Debate(debateID),
    FOREIGN KEY (memberID_minister_of_government) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_member_of_government) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_leader_of_opposition) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_member_of_opposition) REFERENCES Member(memberID))
    ;

CREATE TABLE IF NOT EXISTS LiteraryPresentation (
    literaryPresentationID INT AUTO_INCREMENT PRIMARY KEY,
    date INT NOT NULL,
    memberID INT,
    title VARCHAR(255),
    author VARCHAR(50),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

CREATE TABLE IF NOT EXISTS MemberHumorousDebate (
    memberID INT,
    debateID INT,
    PRIMARY KEY (memberID, debateID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (debateID) REFERENCES HumorousDebate(debateID)
);

CREATE TABLE IF NOT EXISTS MemberSeriousDebate (
    memberID INT,
    debateID INT,
    PRIMARY KEY (memberID, debateID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (debateID) REFERENCES SeriousDebate(debateID)
);

INSERT INTO Member (firstName, lastName, computingID, provideSemester, duesPaid) VALUES ('John', 'Doe', 'jdoe', 'Spring 2024', 1);
INSERT INTO Member (firstName, lastName, computingID, provideSemester, duesPaid) VALUES ('Jane', 'Smith', 'jsmith', 'Fall 2024', 1);
INSERT INTO Member (firstName, lastName, computingID, provideSemester, duesPaid) VALUES ('Jack', 'Evans', 'jevans', 'Spring 2023', 0);
INSERT INTO Member (firstName, lastName, computingID, provideSemester, duesPaid) VALUES ('Liberty', 'Vanty', 'mgs4xm', 'Spring 2021', 1);

INSERT INTO ProvisionalMember (memberID, completed) VALUES (1, 0);
INSERT INTO ProvisionalMember (memberID, completed) VALUES (2, 0);
INSERT INTO ProvisionalMember (memberID, completed) VALUES (3, 0);

INSERT INTO Officers (memberID, position) VALUES (1, 'President');
INSERT INTO Officers (memberID, position) VALUES (2, 'Vice President');
INSERT INTO Officers (memberID, position) VALUES (3, 'Treasurer');

INSERT INTO ProvieRequirements (provID, completed, attendance, fullMeeting, historyTour, majorService, minorService, debate, literaryPresentation) VALUES (1, 0, 1, 0, 1, 0, 1, 1, 1);
INSERT INTO ProvieRequirements (provID, completed, attendance, fullMeeting, historyTour, majorService, minorService, debate, literaryPresentation) VALUES (2, 0, 0, 1, 0, 1, 0, 1, 1);
INSERT INTO ProvieRequirements (provID, completed, attendance, fullMeeting, historyTour, majorService, minorService, debate, literaryPresentation) VALUES (3, 0, 1, 0, 1, 0, 1, 1, 1);

INSERT INTO Debate (date, resolution, debateType, qualityGovernment, qualityOpposition, sentimentGovernment, sentimentOpposition, qualityOverall, sentimentOverall) VALUES (20240602, 'Cats are better than dogs', 'Humorous', 10, 10, 10, 10, 10.00, 10.00);
INSERT INTO Debate (date, resolution, debateType, qualityGovernment, qualityOpposition, sentimentGovernment, sentimentOpposition, qualityOverall, sentimentOverall) VALUES (20240601, 'Beaches are better than mountains', 'Humorous', 9, 9, 9, 9, 9.00, 9.00);
INSERT INTO Debate (date, resolution, debateType, qualityGovernment, qualityOpposition, sentimentGovernment, sentimentOpposition, qualityOverall, sentimentOverall) VALUES (20240531, 'Apples are better than oranges', 'Humorous', 8, 8, 8, 8, 8.00, 8.00);

INSERT INTO HumorousDebate (debateID, memberID_gov1, memberID_gov2, memberID_gov3, memberID_opp1, memberID_opp2, memberID_opp3) VALUES (1, 1, 2, 3, 4, 5, 6);
INSERT INTO HumorousDebate (debateID, memberID_gov1, memberID_gov2, memberID_gov3, memberID_opp1, memberID_opp2, memberID_opp3) VALUES (2, 6, 1, 2, 3, 4, 5);
INSERT INTO HumorousDebate (debateID, memberID_gov1, memberID_gov2, memberID_gov3, memberID_opp1, memberID_opp2, memberID_opp3) VALUES (3, 5, 6, 1, 2, 3, 4);

INSERT INTO SeriousDebate (debateID, memberID_minister_of_government, memberID_member_of_government, memberID_leader_of_opposition, memberID_member_of_opposition) VALUES (1, 1, 2, 3, 4);
INSERT INTO SeriousDebate (debateID, memberID_minister_of_government, memberID_member_of_government, memberID_leader_of_opposition, memberID_member_of_opposition) VALUES (2, 4, 1, 2, 3);
INSERT INTO SeriousDebate (debateID, memberID_minister_of_government, memberID_member_of_government, memberID_leader_of_opposition, memberID_member_of_opposition) VALUES (3, 3, 4, 1, 2);

INSERT INTO LiteraryPresentation (date, memberID, title, author) VALUES (20240523, 1, 'Don Quixote', 'Cervantes');
INSERT INTO LiteraryPresentation (date, memberID, title, author) VALUES (20240522, 2, 'A Tale of Two Cities', 'Charles Dickens');
INSERT INTO LiteraryPresentation (date, memberID, title, author) VALUES (20240521, 3, 'Harry Potter', 'J.K. Rowling');

INSERT INTO MemberHumorousDebate (memberID, debateID) VALUES (1, 1);
INSERT INTO MemberHumorousDebate (memberID, debateID) VALUES (2, 1);
INSERT INTO MemberHumorousDebate (memberID, debateID) VALUES (3, 1);

INSERT INTO MemberSeriousDebate (memberID, debateID) VALUES (1, 1);
INSERT INTO MemberSeriousDebate (memberID, debateID) VALUES (2, 1);
INSERT INTO MemberSeriousDebate (memberID, debateID) VALUES (3, 1);

SELECT *
FROM SeriousDebate;

SELECT *
FROM HumorousDebate;

SELECT *
FROM Member;

SELECT *
FROM Debate;

SELECT *
FROM LiteraryPresentation;

SELECT *
FROM ProvisionalMember;

SELECT *
FROM ProvieRequirements;

SELECT memberID_gov1, memberID_gov2, memberID_gov3, memberID_opp1, memberID_opp2, memberID_opp3
FROM HumorousDebate;

 SELECT memberID_minister_of_government, memberID_member_of_government, memberID_leader_of_opposition, memberID_member_of_opposition
 FROM SeriousDebate;

 SELECT debateID
 FROM Debate;

SELECT AVG(qualityOverall)
FROM Debate AS avg_qualityOverall;

SELECT MIN(qualityOverall)
FROM Debate AS min_qualityOverall;

SELECT MAX(qualityOverall)
FROM Debate AS max_qualityOverall;

SELECT AVG(sentimentOverall)
FROM Debate AS avg_sentimentOverall;

SELECT MIN(sentimentOverall)
FROM Debate AS min_sentimentOverall;

SELECT MAX(sentimentOverall)
FROM Debate AS max_sentimentOverall;

SELECT
    m.memberID,
    m.firstName,
    m.lastName,
    d.debateID,
    d.date,
    d.resolution,
    d.debateType,
    d.qualityOverall,
    d.sentimentOverall
FROM
    Member m
JOIN
    MemberHumorousDebate mhd ON m.memberID = mhd.memberID
JOIN
    HumorousDebate hd ON mhd.debateID = hd.debateID
JOIN
    Debate d ON hd.debateID = d.debateID
UNION
SELECT
    m.memberID,
    m.firstName,
    m.lastName,
    d.debateID,
    d.date,
    d.resolution,
    d.debateType,
    d.qualityOverall,
    d.sentimentOverall
FROM
    Member m
JOIN
    MemberSeriousDebate msd ON m.memberID = msd.memberID
JOIN
    SeriousDebate sd ON msd.debateID = sd.debateID
JOIN
    Debate d ON sd.debateID = d.debateID;

SELECT
    m.memberID,
    m.firstName,
    m.lastName,
    lp.literaryPresentationID,
    lp.date,
    lp.title,
    lp.author
FROM
    Member m
JOIN
    LiteraryPresentation lp ON m.memberID = lp.memberID;

SELECT
    pr.requirementID,
    pr.provID,
    pm.memberID,
    m.firstName,
    m.lastName,
    pr.completed,
    pr.attendance,
    pr.fullMeeting,
    pr.historyTour,
    pr.majorService,
    pr.minorService,
    pr.debate,
    pr.literaryPresentation
FROM
    ProvieRequirements pr
JOIN
    ProvisionalMember pm ON pr.provID = pm.provID
JOIN
    Member m ON pm.memberID = m.memberID;
