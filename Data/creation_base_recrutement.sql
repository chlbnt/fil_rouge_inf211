-- titre :             création base cabinet recrutement version élèves.sql
-- version :           1.0
-- date création :     28 juin 2011
-- date modification : 11 janvier 2022
-- auteur :            eliott quéré / chloé benoit
-- description :       script de création de la base de données pour le si "gestion de cabinet de
--                     recrutement"
--                     note : script pour postgresql
--                     ebauche du script : ne contient pour le moment que la table "entreprise".

-- +----------------------------------------------------------------------------------------------+
-- | suppression des tables                                                                       |
-- +----------------------------------------------------------------------------------------------+

drop table if exists entreprise cascade;
drop table if exists offre_emploi cascade;
drop table if exists message_offre_d_emploi cascade;
drop table if exists niveau_qualification cascade;
drop table if exists candidature cascade;
drop table if exists message_candidature cascade;
drop table if exists secteur_activite cascade;
drop table if exists index_offre_emploi_secteur_activite cascade;
drop table if exists index_candidature_secteur_activite cascade;

-- +----------------------------------------------------------------------------------------------+
-- | création des tables                                                                          |
-- +----------------------------------------------------------------------------------------------+

create table entreprise
(
	id_entreprise				serial primary key,
	nom							varchar(50) not null,
	descriptif					text,
	adresse_postale				varchar(30) -- pour simplifier, adresse_postale = ville.
);

create table niveau_qualification
(
	id_niveau_qualification		serial primary key,
	intitule 					varchar(50) not null
);

create table secteur_activite
(
	id_secteur_activite			serial primary key,
	intitule	 				text not null 
);


create table offre_emploi
(
	id_offre_emploi				serial primary key,
	titre						varchar(50) not null,
	description_mission			text,
	profil_recherche			text,
	date_depot					date not null,
	id_entreprise				int not null references entreprise(id_entreprise),
	id_niveau_qualification		int not null references niveau_qualification(id_niveau_qualification)
);

create table candidature
(
	id_candidature				serial primary key, -- cand_numéro_candidature
	nom 						varchar(50) not null,
	prenom 						varchar(50) not null,
	date_naissance				date not null,
	ville						varchar(30),
	adresse_email				varchar(50),
	cv			 				text,
	date_depot					date not null,
	id_niveau_qualification 	int not null references niveau_qualification(id_niveau_qualification)
);

create table message_offre_emploi
(
	id_message_offre_emploi		serial primary key,
	date_envoi					date not null,
	corps_message 				text,
	id_offre_emploi				int not null references offre_emploi(id_offre_emploi),
	id_candidature				int not null references candidature(id_candidature)
);


create table message_candidature
(
	id_message_candidature		serial primary key,
	date_envoi					date not null,
	corps_message	 			text,
	id_offre_emploi			 	int not null references offre_emploi(id_offre_emploi),
	id_candidature 			 	int not null references candidature(id_candidature)
);

create table index_offre_emploi_secteur_activite
(
	id_offre_emploi			 	int references offre_emploi(id_offre_emploi),
	id_secteur_activite 		int references secteur_activite(id_secteur_activite),
	primary key (id_offre_emploi,id_secteur_activite)
);

create table index_candidature_secteur_activite
(
	id_candidature			 	int references candidature(id_candidature),
	id_secteur_activite 		int references secteur_activite (id_secteur_activite),
	primary key (id_candidature,id_secteur_activite)
);

-- Insertion des données de test dans la table 'entreprise'
INSERT INTO entreprise (nom, descriptif, adresse_postale)
VALUES ('Entreprise A', 'Notre entreprise est spécialisée dans la production de widgets.', 'Paris');

INSERT INTO entreprise (nom, descriptif, adresse_postale)
VALUES ('Entreprise B', 'Notre entreprise est spécialisée dans la production de gadgets.', 'Lyon');

-- Insertion des données de test dans la table 'niveau_qualification'
INSERT INTO niveau_qualification (intitule)
VALUES ('Bac+2');

INSERT INTO niveau_qualification (intitule)
VALUES ('Bac+5');

-- Insertion des données de test dans la table 'secteur_activite'
INSERT INTO secteur_activite (intitule)
VALUES ('Informatique');

INSERT INTO secteur_activite (intitule)
VALUES ('Chimie');

-- Insertion des données de test dans la table 'offre_emploi'
INSERT INTO offre_emploi (titre, description_mission, profil_recherche, date_depot, id_entreprise, id_niveau_qualification)
VALUES ('Développeur Java', 'Nous recherchons un développeur expérimenté pour rejoindre notre équipe en charge du développement d''une application web', 'Expérience en développement Java, connaissance de Spring et Hibernate', '2022-01-01', 1, 1);

INSERT INTO offre_emploi (titre, description_mission, profil_recherche, date_depot, id_entreprise, id_niveau_qualification)
VALUES ('Ingénieur R&D', 'Nous recherchons un ingénieur en R&D pour développer des produits innovants dans le domaine de la chimie', 'Diplôme d''ingénieur en chimie, expérience en R&D', '2022-02-01', 2, 2);

-- Insertion des données de test dans la table 'candidature'
INSERT INTO candidature (nom, prenom, date_naissance, adresse_postale, adresse_email, cv, date_depot, id_niveau_qualification)
VALUES ('Dupont', 'Jean', '1990-01-01', 'Marseille', 'jean.dupont@gmail.com', 'Mon CV en PDF', '2022-03-01', 1);

INSERT INTO candidature (nom, prenom, date_naissance, adresse_postale, adresse_email, cv, date_depot, id_niveau_qualification)
VALUES ('Martin', 'Sophie', '1995-05-01', 'Lyon', 'sophie.martin@gmail.com', 'Mon CV en PDF', '2022-04-01', 2);

-- Insertion des données de test dans la table 'message_offre_emploi'
INSERT INTO message_offre_emploi (date_envoi, corps_message, id_offre_emploi, id_candidature)
VALUES ('2022-05-01', 'Bonjour, je suis intéressé par votre offre d''emploi et souhaite postuler', 1, 1);

INSERT INTO message_offre_emploi (date_envoi, corps_message, id_offre_emploi, id_candidature)
VALUES ('2022-06-01', 'Bonjour, je suis très intéressé par votre offre d''emploi et pense être un bon candidat', 2, 2);

-- Insertion des données de test dans la table 'message_candidature'
INSERT INTO message_candidature (date_envoi, corps_message, id_offre_emploi, id_candidature)
VALUES ('2022-07-01', 'Bonjour, je vous remercie pour votre intérêt à mon profil et souhaite en savoir plus sur les prochaines étapes de la candidature', 1, 1);

INSERT INTO message_candidature (date_envoi, corps_message, id_offre_emploi, id_candidature)
VALUES ('2022-08-01', 'Bonjour, je vous remercie pour votre intérêt à mon profil et suis disponible pour un entretien téléphonique', 2, 2);

-- Insertion des données de test dans la table 'index_offre_emploi_secteur_activite'
INSERT INTO index_offre_emploi_secteur_activite (id_offre_emploi, id_secteur_activite)
VALUES (1, 1);

INSERT INTO index_offre_emploi_secteur_activite (id_offre_emploi, id_secteur_activite)
VALUES ((SELECT id_offre_emploi FROM offre_emploi WHERE titre = 'Développeur Java'), (SELECT id_secteur_activite FROM secteur_activite WHERE intitule = 'Informatique'));

INSERT INTO index_offre_emploi_emploi_secteur_activite (id_offre_emploi, id_secteur_activite)
VALUES ((SELECT id_offre_emploi FROM offre_emploi WHERE titre = 'Ingénieur R&D'), (SELECT id_secteur_activite FROM secteur_activite WHERE intitule = 'Chimie'));






