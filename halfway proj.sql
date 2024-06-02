CREATE TABLE Member (
    memberID VARCHAR(50) PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    computingID VARCHAR(50) NOT NULL,
    provideSemester VARCHAR(50) NOT NULL,
    duesPaid BOOLEAN NOT NULL
);

CREATE TABLE ProvisionalMember (
    provID VARCHAR(50) PRIMARY KEY,
    memberID VARCHAR(50),
    completed BOOLEAN NOT NULL,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

CREATE TABLE ProvieRequirements (
    requirementID VARCHAR(50) PRIMARY KEY,
    provID VARCHAR(50),
    completed BOOLEAN NOT NULL,
    attendance BOOLEAN NOT NULL,
    fullMeeting BOOLEAN NOT NULL,
    historyTour BOOLEAN NOT NULL,
    majorService BOOLEAN NOT NULL,
    minorService BOOLEAN NOT NULL,
    debate BOOLEAN NOT NULL,
    literaryPresentation BOOLEAN NOT NULL,
    FOREIGN KEY (provID) REFERENCES ProvisionalMember(provID)
);

CREATE TABLE Debate (
    debateID VARCHAR(50) PRIMARY KEY,
    date INT NOT NULL,
    resolution VARCHAR(1000) NOT NULL,
    debateType VARCHAR(50) NOT NULL,
    qualityGovernment INT,
    qualityOpposition INT,
    sentimentGovernment INT,
    sentimentOpposition INT,
    qualityOverall DECIMAL(4,2),
    sentimentOverall DECIMAL(4,2)
);

CREATE TABLE HumorousDebate (
    debateID VARCHAR(50) PRIMARY KEY,
    memberID_gov1 VARCHAR(50),
    memberID_gov2 VARCHAR(50),
    memberID_gov3 VARCHAR(50),
    memberID_opp1 VARCHAR(50),
    memberID_opp2 VARCHAR(50),
    memberID_opp3 VARCHAR(50),
    FOREIGN KEY (debateID) REFERENCES Debate(debateID),
    FOREIGN KEY (memberID_gov1) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_gov2) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_gov3) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_opp1) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_opp2) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_opp3) REFERENCES Member(memberID)
);

CREATE TABLE SeriousDebate (
    debateID VARCHAR(50) PRIMARY KEY,
    memberID_minister_of_government VARCHAR(50),
    memberID_member_of_government VARCHAR(50),
    memberID_leader_of_opposition VARCHAR(50),
    memberID_member_of_opposition VARCHAR(50),
    FOREIGN KEY (debateID) REFERENCES Debate(debateID),
    FOREIGN KEY (memberID_minister_of_government) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_member_of_government) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_leader_of_opposition) REFERENCES Member(memberID),
    FOREIGN KEY (memberID_member_of_opposition) REFERENCES Member(memberID))
    ;

CREATE TABLE LiteraryPresentation (
    literaryPresentationID VARCHAR(50) PRIMARY KEY,
    date INT NOT NULL,
    memberID VARCHAR(50),
    title VARCHAR(255),
    author VARCHAR(50),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

CREATE TABLE MemberHumorousDebate (
    memberID VARCHAR(50),
    debateID VARCHAR(50),
    PRIMARY KEY (memberID, debateID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (debateID) REFERENCES HumorousDebate(debateID)
);

CREATE TABLE MemberSeriousDebate (
    memberID VARCHAR(50),
    debateID VARCHAR(50),
    PRIMARY KEY (memberID, debateID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (debateID) REFERENCES SeriousDebate(debateID)
);

INSERT INTO Member VALUES('123456','John','Doe','abcd','Spring 2024','1');
INSERT INTO Member VALUES('234567','Jane','Smith','bcde','Fall 2024','1');
INSERT INTO Member VALUES('345678','Jack','Evans','cdef','Spring 2023','0');
INSERT INTO Member VALUES('456789','Tabia','Doza','defg','Summer 2024','0');
INSERT INTO Member VALUES('567890','Liberty','Vanty','efgh','Summer 2024','1');
INSERT INTO Member VALUES('678901','Seung','Lee','fghi','Summer 2024','1');

INSERT INTO ProvisionalMember VALUES('a23456','123456','0');
INSERT INTO ProvisionalMember VALUES('b34567','234567','0');
INSERT INTO ProvisionalMember VALUES('c45678','345678','0');
INSERT INTO ProvisionalMember VALUES('d56789','456789','0');

INSERT INTO ProvieRequirements VALUES('z23456','a23456','0','1','0','1','0','1','1','1');
INSERT INTO ProvieRequirements VALUES('y34567','b34567','0','0','1','0','1','0','1','1');
INSERT INTO ProvieRequirements VALUES('x45678','c45678','0','1','0','1','0','1','1','1');
INSERT INTO ProvieRequirements VALUES('w56789','d56789','0','0','1','0','1','0','1','1');

INSERT INTO Debate VALUES('zyx','20240602','Cats are better than dogs','Humorous','10','10','10','10','10','10');
INSERT INTO Debate VALUES('yxw','20240601','Beaches are better than mountains','Humorous','9','9','9','9','9','9');
INSERT INTO Debate VALUES('xwv','20240531','Apples are better than oranges','Humorous','8','8','8','8','8','8');
INSERT INTO Debate VALUES('wvu','20240530','Books are better than movies','Humorous','7','7','7','7','7','7');
INSERT INTO Debate VALUES('vut','20240529','Hot is better than cold','Humorous','6','6','6','6','6','6');
INSERT INTO Debate VALUES('uts','20240528','Sunny is better than cloudy','Serious','5','5','5','5','5','5');
INSERT INTO Debate VALUES('tsr','20240527','West coast is better than East coast','Serious','4','4','4','4','4','4');
INSERT INTO Debate VALUES('srq','20240526','Honda is better than Toyota','Serious','3','3','3','3','3','3');
INSERT INTO Debate VALUES('rqp','20240525','School is better than work','Serious','2','2','2','2','2','2');
INSERT INTO Debate VALUES('qpo','20240524','Day is better than night','Serious','1','1','1','1','1','1');

INSERT INTO HumorousDebate VALUES('zyx','123456','234567','345678','456789','567890','678901');
INSERT INTO HumorousDebate VALUES('yxw','678901','123456','234567','345678','456789','567890');
INSERT INTO HumorousDebate VALUES('xwv','567890','678901','123456','234567','345678','456789');
INSERT INTO HumorousDebate VALUES('wvu','456789','567890','678901','123456','234567','345678');
INSERT INTO HumorousDebate VALUES('vut','345678','456789','567890','678901','123456','234567');

INSERT INTO SeriousDebate VALUES('uts','123456','234567','345678','456789');
INSERT INTO SeriousDebate VALUES('tsr','678901','123456','234567','345678');
INSERT INTO SeriousDebate VALUES('srq','567890','678901','123456','234567');
INSERT INTO SeriousDebate VALUES('rqp','456789','567890','678901','123456');
INSERT INTO SeriousDebate VALUES('qpo','345678','456789','567890','678901');

INSERT INTO MemberHumorousDebate VALUES('123456','zyx');
INSERT INTO MemberHumorousDebate VALUES('234567','zyx');
INSERT INTO MemberHumorousDebate VALUES('345678','zyx');
INSERT INTO MemberHumorousDebate VALUES('456789','zyx');
INSERT INTO MemberHumorousDebate VALUES('567890','zyx');
INSERT INTO MemberHumorousDebate VALUES('678901','zyx');
INSERT INTO MemberHumorousDebate VALUES('123456','yxw');
INSERT INTO MemberHumorousDebate VALUES('234567','yxw');
INSERT INTO MemberHumorousDebate VALUES('345678','yxw');
INSERT INTO MemberHumorousDebate VALUES('456789','yxw');
INSERT INTO MemberHumorousDebate VALUES('567890','yxw');
INSERT INTO MemberHumorousDebate VALUES('678901','yxw');
INSERT INTO MemberHumorousDebate VALUES('123456','xwv');
INSERT INTO MemberHumorousDebate VALUES('234567','xwv');
INSERT INTO MemberHumorousDebate VALUES('345678','xwv');
INSERT INTO MemberHumorousDebate VALUES('456789','xwv');
INSERT INTO MemberHumorousDebate VALUES('567890','xwv');
INSERT INTO MemberHumorousDebate VALUES('678901','xwv');
INSERT INTO MemberHumorousDebate VALUES('123456','wvu');
INSERT INTO MemberHumorousDebate VALUES('234567','wvu');
INSERT INTO MemberHumorousDebate VALUES('345678','wvu');
INSERT INTO MemberHumorousDebate VALUES('456789','wvu');
INSERT INTO MemberHumorousDebate VALUES('567890','wvu');
INSERT INTO MemberHumorousDebate VALUES('678901','wvu');
INSERT INTO MemberHumorousDebate VALUES('123456','vut');
INSERT INTO MemberHumorousDebate VALUES('234567','vut');
INSERT INTO MemberHumorousDebate VALUES('345678','vut');
INSERT INTO MemberHumorousDebate VALUES('456789','vut');
INSERT INTO MemberHumorousDebate VALUES('567890','vut');
INSERT INTO MemberHumorousDebate VALUES('678901','vut');

INSERT INTO MemberSeriousDebate VALUES('123456','uts');
INSERT INTO MemberSeriousDebate VALUES('234567','uts');
INSERT INTO MemberSeriousDebate VALUES('345678','uts');
INSERT INTO MemberSeriousDebate VALUES('456789','uts');
INSERT INTO MemberSeriousDebate VALUES('123456','tsr');
INSERT INTO MemberSeriousDebate VALUES('234567','tsr');
INSERT INTO MemberSeriousDebate VALUES('345678','tsr');
INSERT INTO MemberSeriousDebate VALUES('678901','tsr');
INSERT INTO MemberSeriousDebate VALUES('123456','srq');
INSERT INTO MemberSeriousDebate VALUES('234567','srq');
INSERT INTO MemberSeriousDebate VALUES('567890','srq');
INSERT INTO MemberSeriousDebate VALUES('678901','srq');
INSERT INTO MemberSeriousDebate VALUES('123456','rqp');
INSERT INTO MemberSeriousDebate VALUES('456789','rqp');
INSERT INTO MemberSeriousDebate VALUES('567890','rqp');
INSERT INTO MemberSeriousDebate VALUES('678901','rqp');
INSERT INTO MemberSeriousDebate VALUES('345678','qpo');
INSERT INTO MemberSeriousDebate VALUES('456789','qpo');
INSERT INTO MemberSeriousDebate VALUES('567890','qpo');
INSERT INTO MemberSeriousDebate VALUES('678901','qpo');

INSERT INTO LiteraryPresentation VALUES('azb','20240523','123456','Don Quixote','Cervantes');
INSERT INTO LiteraryPresentation VALUES('byc','20240522','234567','A Tale of Two Cities','Charles Dickens');
INSERT INTO LiteraryPresentation VALUES('cxd','20240521','345678','Harry Potter','J.K. Rowling');
INSERT INTO LiteraryPresentation VALUES('dwe','20240520','456789','The Hobbit','J.R.R. Tolkien');
INSERT INTO LiteraryPresentation VALUES('evf','20240519','567890','The Lion, the Witch and the Wardrobe','C.S. Lewis');

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