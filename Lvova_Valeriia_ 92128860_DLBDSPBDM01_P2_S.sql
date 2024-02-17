
CREATE DATABASE datamart_Lvova;


-- 1 User contact table
CREATE TABLE user_contact (
    user_contact_id INT PRIMARY KEY,
    phone_number VARCHAR(20),
    email VARCHAR(255),
    facebook_url VARCHAR(500)
);

CREATE TYPE login_type AS ENUM ('google', 'email', 'phone_number');
-- 2 User preferences table
CREATE TABLE user_preferences (
    preference_id INT PRIMARY KEY,
    two_fa BOOLEAN,
    login_type login_type NOT NULL,
	data_sharing BOOLEAN,
	news_subscription BOOLEAN
);

-- 3 Language table
CREATE TABLE language (
    language_id INT PRIMARY KEY,
    language_name VARCHAR(50),
    language_code VARCHAR(3)
);

CREATE TYPE type_card AS ENUM ('MasterCard', 'Visa', 'Maestro');
-- 4 Payment card table
CREATE TABLE payment_card (
    payment_card_id INT PRIMARY KEY,
	type_card type_card NOT NULL,
    card_number BIGINT,
    expiration_date DATE,
    holder_name VARCHAR(255)
);

-- 5 Address table
CREATE TABLE address (
    address_id INT PRIMARY KEY,
    country VARCHAR(50),
    state_of_country VARCHAR(50),
    city VARCHAR(50),
    zip_code VARCHAR(50),
    street VARCHAR(500),
    house_num SMALLINT
);

-- 6 Guest table
CREATE TABLE guest (
    guest_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age SMALLINT
);

-- 7 Host table
CREATE TABLE host (
    host_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age SMALLINT
);
-- 8 User fact table
CREATE TABLE user_fact(
user_id INT PRIMARY KEY,
guest_id INT,
host_id INT,
address_id INT,
user_contact_id INT,
payment_card_id INT,
language_id INT,
preference_id INT,
FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
FOREIGN KEY (host_id) REFERENCES host(host_id),
FOREIGN KEY (address_id) REFERENCES address(address_id),
FOREIGN KEY (user_contact_id) REFERENCES user_contact(user_contact_id),
FOREIGN KEY (payment_card_id) REFERENCES payment_card(payment_card_id),
FOREIGN KEY (language_id) REFERENCES language(language_id),
FOREIGN KEY (preference_id) REFERENCES user_preferences(preference_id)
);

-- 9 House rules table
CREATE TABLE house_rules (
    rules_id INT PRIMARY KEY,
    smoking_allowed BOOLEAN,
    animals_allowed BOOLEAN,
    kids_allowed BOOLEAN,
	own_food_allowed BOOLEAN,
	late_check_out BOOLEAN
);

CREATE TYPE property_type AS ENUM ('Apartment', 'Villa', 'Room');
-- 10 Property table
CREATE TABLE property (
    property_id INT PRIMARY KEY,
    property_name VARCHAR(100),
    property_type property_type NOT NULL,
	number_of_rooms INT,
    price_per_night DECIMAL (10,2)
);

-- 11 Amenities table
CREATE TABLE amenities (
    amenity_id INT PRIMARY KEY,
    swimming_pool BOOLEAN,
    breakfast BOOLEAN,
    wi_fi BOOLEAN,
    hot_tub BOOLEAN,
	spa BOOLEAN
);
-- 12 Location table
CREATE TABLE location (
    location_id INT PRIMARY KEY,
    country VARCHAR(50),
    state_of_country VARCHAR(50),
    city VARCHAR(50)
);
-- 13 Accommodation table
CREATE TABLE accommodation (
    accommodation_id INT PRIMARY KEY,
    property_id INT,
    address_id INT,
	location_id INT,
    amenity_id INT,
    rules_id INT,
    host_id INT,
    FOREIGN KEY (property_id) REFERENCES property(property_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
	FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id),
    FOREIGN KEY (rules_id) REFERENCES house_rules(rules_id),
    FOREIGN KEY (host_id) REFERENCES host(host_id)
);

CREATE TYPE location_stars AS ENUM('1', '2', '3', '4', '5');
CREATE TYPE cleanliness_stars AS ENUM('1', '2', '3', '4', '5');
CREATE TYPE hospitality_stars AS ENUM('1', '2', '3', '4', '5');

-- 14 Property review table
CREATE TABLE property_review (
    property_review_id INT PRIMARY KEY,
    text_review TEXT,
    location_stars location_stars,
    cleanliness_stars cleanliness_stars,
    hospitality_stars hospitality_stars
);

-- 15 Accommodation rating table
CREATE TABLE accommodation_rating (
    accommodation_rating_id INT PRIMARY KEY,
	property_id INT,
	host_id INT,
	guest_id INT,
	amenity_id INT,
    property_review_id INT,
	FOREIGN KEY(property_id) REFERENCES property(property_id),
	FOREIGN KEY(host_id) REFERENCES host(host_id),
	FOREIGN KEY(guest_id) REFERENCES guest(guest_id),
	FOREIGN KEY(amenity_id) REFERENCES amenities(amenity_id),
    FOREIGN KEY (property_review_id) REFERENCES property_review(property_review_id)
);
-- 16 Transaction table
CREATE TABLE transaction (
    transaction_id INT PRIMARY KEY,
    transaction_number VARCHAR(50),
    amount DECIMAL(10, 2)
);
-- 17 Date table
CREATE TABLE date (
    date_id INT PRIMARY KEY,
    actual_date DATE,
    "year" INT,
    "month" INT,
    is_weekend BOOLEAN
);

-- 18 Special offer table
CREATE TABLE special_offer (
    offer_id INT PRIMARY KEY,
	code VARCHAR(10),
    description VARCHAR(100),
    start_date DATE,
    end_date DATE
);
-- 19 Income calculator table
CREATE TABLE income_calculator (
    calculation_id INT PRIMARY KEY,
    property_id INT,
    host_id INT,
    amenity_id INT,
    location_id INT,
	host_income_per_day DECIMAL(10,2),
	website_income_per_day DECIMAL(10,2),
    guest_commission DECIMAL(2, 2),
    host_commission DECIMAL(2, 2),
    FOREIGN KEY (property_id) REFERENCES property(property_id),
    FOREIGN KEY (host_id) REFERENCES host(host_id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

CREATE TYPE booking_status AS ENUM ('Confirmed', 'On hold', 'Canceled');
CREATE TYPE stay_reason AS ENUM ('Work', 'Study', 'Vacation');
-- 20 Booking table
CREATE TABLE booking (
    booking_id INT PRIMARY KEY,
    guest_id INT,
    host_id INT,
    property_id INT,
    date_id INT,
    transaction_id INT,
    offer_id INT,
    booking_status booking_status NOT NULL,
    stay_reason stay_reason NOT NULL,
    check_in_date DATE,
    check_out_date DATE,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
    FOREIGN KEY (host_id) REFERENCES host(host_id),
    FOREIGN KEY (property_id) REFERENCES property(property_id),
    FOREIGN KEY (date_id) REFERENCES date(date_id),
    FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id),
    FOREIGN KEY (offer_id) REFERENCES special_offer(offer_id)
);

-- 1 Values for user_contact table
INSERT INTO user_contact (user_contact_id, phone_number, email, facebook_url) VALUES
(1, '+31201234567', 'daan.jansen@email.com', 'https://facebook.com/daanjansen'),
(2, '+31201234568', 'emma.devries@email.com', 'https://facebook.com/emmadevries'),
(3, '+31201234569', 'levi.bakker@email.com', 'https://facebook.com/levibakker'),
(4, '+31201234570', 'sophie.vandijk@email.com', 'https://facebook.com/sophievandijk'),
(5, '+31201234571', 'bram.visser@email.com', 'https://facebook.com/bramvisser'),
(6, '+31201234572', 'tess.smit@email.com', 'https://facebook.com/tesssmit'),
(7, '+31201234573', 'sem.meijer@email.com', 'https://facebook.com/semmeijer'),
(8, '+31201234574', 'anna.deboer@email.com', 'https://facebook.com/annadeboer'),
(9, '+31201234575', 'finn.mulder@email.com', 'https://facebook.com/finnmulder'),
(10, '+31201234576', 'eva.bos@email.com', 'https://facebook.com/evabos'),
(11, '+5521987654321', 'gabriel.garcia@email.com', 'https://facebook.com/gabrielgarcia'),
(12, '+5492211234567', 'lucas.rodriguez@email.com', 'https://facebook.com/lucasrodriguez'),
(13, '+56912345678', 'sofia.silva@email.com', 'https://facebook.com/sofiasilva'),
(14, '+51912345678', 'mateo.martinez@email.com', 'https://facebook.com/mateomartinez'),
(15, '+5791234567', 'camila.lopez@email.com', 'https://facebook.com/camilalopez'),
(16, '+33612345678', 'oliver.smith@email.com', 'https://facebook.com/oliversmith'),
(17, '+4915123456789', 'charlotte.jones@email.com', 'https://facebook.com/charlottejones'),
(18, '+34612345678', 'harry.taylor@email.com', 'https://facebook.com/harrytaylor'),
(19, '+393123456789', 'amelia.brown@email.com', 'https://facebook.com/ameliabrown'),
(20, '+447123456789', 'jack.wilson@email.com', 'https://facebook.com/jackwilson');


-- 2 Values for user_preference table
INSERT INTO user_preferences (preference_id, two_fa, login_type, data_sharing, news_subscription) VALUES
(1, TRUE, 'email', TRUE, FALSE),
(2, FALSE, 'google', FALSE, TRUE),
(3, TRUE, 'phone_number', TRUE, TRUE),
(4, FALSE, 'email', FALSE, FALSE),
(5, TRUE, 'google', FALSE, TRUE),
(6, FALSE, 'phone_number', TRUE, FALSE),
(7, TRUE, 'email', FALSE, FALSE),
(8, FALSE, 'google', TRUE, TRUE),
(9, TRUE, 'phone_number', TRUE, TRUE),
(10, FALSE, 'email', FALSE, FALSE),
(11, TRUE, 'google', TRUE, FALSE),
(12, FALSE, 'phone_number', FALSE, TRUE),
(13, TRUE, 'email', FALSE, FALSE),
(14, FALSE, 'google', TRUE, TRUE),
(15, TRUE, 'phone_number', TRUE, TRUE),
(16, FALSE, 'email', FALSE, FALSE),
(17, TRUE, 'google', TRUE, FALSE),
(18, FALSE, 'phone_number', FALSE, TRUE),
(19, TRUE, 'email', FALSE, TRUE),
(20, FALSE, 'google', TRUE, FALSE);


-- 3 Values for language table
INSERT INTO language (language_id, language_name, language_code) VALUES
(1, 'English', 'en'),
(2, 'Spanish', 'es'),
(3, 'Portuguese', 'pt'),
(4, 'German', 'de'),
(5, 'French', 'fr'),
(6, 'Dutch', 'nl'),
(7, 'Italian', 'it'),
(8, 'Russian', 'ru'),
(9, 'Swedish', 'sv'),
(10, 'Danish', 'da'),
(11, 'Norwegian', 'no'),
(12, 'Finnish', 'fi'),
(13, 'Polish', 'pl'),
(14, 'Turkish', 'tr'),
(15, 'Greek', 'el'),
(16, 'Quechua', 'qu'),
(17, 'Aymara', 'ay'),
(18, 'Guarani', 'gn'),
(19, 'Mapudungun', 'arn'),
(20, 'Welsh', 'cy');

-- 4 Values for payment_card table
INSERT INTO payment_card (payment_card_id, type_card, card_number, expiration_date, holder_name) VALUES
(1, 'Visa', 1234567890123456, '2024-12-31', 'Jansen, Daan'),
(2, 'MasterCard', 2345678901234567, '2023-11-30', 'De Vries, Emma'),
(3, 'Maestro', 3456789012345678, '2025-01-15', 'Bakker, Levi'),
(4, 'Visa', 4567890123456789, '2024-10-28', 'Van Dijk, Sophie'),
(5, 'MasterCard', 5678901234567890, '2023-09-17', 'Visser, Bram'),
(6, 'Maestro', 6789012345678901, '2025-03-21', 'Smit, Tess'),
(7, 'Visa', 7890123456789012, '2024-07-11', 'Meijer, Sem'),
(8, 'MasterCard', 8901234567890123, '2023-05-30', 'De Boer, Anna'),
(9, 'Maestro', 9012345678901234, '2025-08-19', 'Mulder, Finn'),
(10, 'Visa', 1234567890123457, '2024-11-29', 'Bos, Eva'),
(11, 'MasterCard', 2345678901234568, '2023-12-14', 'García, Gabriel'),
(12, 'Maestro', 3456789012345679, '2025-02-23', 'Rodriguez, Lucas'),
(13, 'Visa', 4567890123456790, '2024-09-18', 'Silva, Sofia'),
(14, 'MasterCard', 5678901234567901, '2023-04-12', 'Martinez, Mateo'),
(15, 'Maestro', 6789012345679012, '2025-06-27', 'Lopez, Camila'),
(16, 'Visa', 7890123456789013, '2024-03-31', 'Smith, Oliver'),
(17, 'MasterCard', 8901234567890124, '2023-07-20', 'Jones, Charlotte'),
(18, 'Maestro', 9012345678901235, '2025-05-15', 'Taylor, Harry'),
(19, 'Visa', 1234567890123458, '2024-01-22', 'Brown, Amelia'),
(20, 'MasterCard', 2345678901234569, '2023-08-10', 'Wilson, Jack');

-- 5 Values for address table
INSERT INTO address (address_id, country, state_of_country, city, zip_code, street, house_num) VALUES
(1, 'Netherlands', 'North Holland', 'Amsterdam', '1011', 'Dam Square', 1),
(2, 'Netherlands', 'North Holland', 'Haarlem', '2011', 'Grote Markt', 2),
(3, 'Netherlands', 'South Holland', 'Rotterdam', '3011', 'Erasmusbrug', 3),
(4, 'Netherlands', 'Utrecht', 'Utrecht', '3511', 'Domplein', 4),
(5, 'Netherlands', 'North Brabant', 'Eindhoven', '5611', 'Stratumseind', 5),
(6, 'Netherlands', 'Limburg', 'Maastricht', '6211', 'Vrijthof', 6),
(7, 'Netherlands', 'Overijssel', 'Enschede', '7511', 'Oude Markt', 7),
(8, 'Netherlands', 'Gelderland', 'Nijmegen', '6511', 'Grote Markt', 8),
(9, 'Netherlands', 'North Holland', 'Alkmaar', '1811', 'Waagplein', 9),
(10, 'Netherlands', 'Friesland', 'Leeuwarden', '8911', 'Oldehove', 10),
(11, 'Brazil', 'São Paulo', 'São Paulo', '01000-000', 'Paulista Avenue', 11),
(12, 'Argentina', 'Buenos Aires', 'Buenos Aires', 'C1001', 'Casa Rosada', 12),
(13, 'Chile', 'Santiago Metropolitan', 'Santiago', '8320000', 'La Moneda', 13),
(14, 'Peru', 'Lima Province', 'Lima', '15001', 'Plaza Mayor', 14),
(15, 'Colombia', 'Bogota D.C', 'Bogota', '110111', 'Bolivar Square', 15),
(16, 'France', 'Île-de-France', 'Paris', '75001', 'Eiffel Tower', 16),
(17, 'Germany', 'Berlin', 'Berlin', '10115', 'Brandenburg Gate', 17),
(18, 'Spain', 'Community of Madrid', 'Madrid', '28001', 'Puerta del Sol', 18),
(19, 'Italy', 'Lazio', 'Rome', '00118', 'Colosseum', 19),
(20, 'United Kingdom', 'England', 'London', 'SW1A 1AA', 'Buckingham Palace', 20);

--6 Values for guest table
INSERT INTO guest (guest_id, first_name, last_name, age) VALUES
(1, 'Daan', 'Jansen', 28),
(2, 'Emma', 'De Vries', 26),
(3, 'Levi', 'Bakker', 32),
(4, 'Sophie', 'Van Dijk', 30),
(5, 'Bram', 'Visser', 35),
(6, 'Tess', 'Smit', 29),
(7, 'Sem', 'Meijer', 31),
(8, 'Anna', 'De Boer', 27),
(9, 'Finn', 'Mulder', 33),
(10, 'Eva', 'Bos', 25),
(11, 'Gabriel', 'García', 34),
(12, 'Lucas', 'Rodriguez', 29),
(13, 'Sofia', 'Silva', 28),
(14, 'Mateo', 'Martinez', 35),
(15, 'Camila', 'Lopez', 26),
(16, 'Oliver', 'Smith', 30),
(17, 'Charlotte', 'Jones', 31),
(18, 'Harry', 'Taylor', 32),
(19, 'Amelia', 'Brown', 27),
(20, 'Jack', 'Wilson', 29);

-- 7 Values for host table
INSERT INTO host (host_id, first_name, last_name, age) VALUES
(1, 'Daan', 'Jansen', 28),
(2, 'Emma', 'De Vries', 26),
(3, 'Levi', 'Bakker', 32),
(4, 'Sophie', 'Van Dijk', 30),
(5, 'Bram', 'Visser', 35),
(6, 'Tess', 'Smit', 29),
(7, 'Sem', 'Meijer', 31),
(8, 'Anna', 'De Boer', 27),
(9, 'Finn', 'Mulder', 33),
(10, 'Eva', 'Bos', 25),
(11, 'Gabriel', 'García', 34),
(12, 'Lucas', 'Rodriguez', 29),
(13, 'Sofia', 'Silva', 28),
(14, 'Mateo', 'Martinez', 35),
(15, 'Camila', 'Lopez', 26),
(16, 'Oliver', 'Smith', 30),
(17, 'Charlotte', 'Jones', 31),
(18, 'Harry', 'Taylor', 32),
(19, 'Amelia', 'Brown', 27),
(20, 'Jack', 'Wilson', 29);

-- 8 Values for user_fact table
INSERT INTO user_fact (user_id, guest_id, host_id, address_id, user_contact_id, payment_card_id, language_id, preference_id) VALUES
(1, 1, 1, 1, 1, 1, 6, 1),
(2, 2, 2, 2, 2, 1, 6, 2),
(3, 3, 3, 3, 3, 3, 6, 3),
(4, 4, 4, 4, 4, 4, 6, 4),
(5, 5, 5, 5, 5, 5, 6, 5),
(6, 6, 6, 6, 6, 6, 6, 6),
(7, 7, 7, 7, 7, 7, 6, 7),
(8, 8, 8, 8, 8, 8, 6, 8),
(9, 9, 9, 9, 9, 9, 6, 9),
(10, 10, 10, 10, 10, 10, 6, 10),
(11, 11, 11, 11, 11, 11, 2, 11),
(12, 12, 12, 12, 12, 12, 2, 12),
(13, 13, 13, 13, 13, 13, 2, 13),
(14, 14, 14, 14, 14, 14, 2, 14),
(15, 15, 15, 15, 15, 15, 2, 15),
(16, 16, 16, 16, 16, 16, 5, 16),
(17, 17, 17, 17, 17, 17, 4, 17),
(18, 18, 18, 18, 18, 18, 2, 18),
(19, 19, 19, 19, 19, 19, 7, 19),
(20, 20, 20, 20, 20, 20, 3, 20);


-- 9 Values for house_rules table
INSERT INTO house_rules (rules_id, smoking_allowed, animals_allowed, kids_allowed, own_food_allowed, late_check_out) VALUES
(1, TRUE, TRUE, TRUE, TRUE, TRUE),
(2, FALSE, TRUE, TRUE, FALSE, FALSE),
(3, TRUE, FALSE, TRUE, TRUE, TRUE),
(4, TRUE, TRUE, FALSE, FALSE, FALSE),
(5, FALSE, FALSE, TRUE, TRUE, TRUE),
(6, TRUE, FALSE, FALSE, TRUE, FALSE),
(7, FALSE, TRUE, FALSE, FALSE, TRUE),
(8, TRUE, TRUE, TRUE, FALSE, FALSE),
(9, FALSE, FALSE, FALSE, TRUE, TRUE),
(10, TRUE, FALSE, TRUE, FALSE, FALSE),
(11, FALSE, TRUE, FALSE, TRUE, TRUE),
(12, TRUE, TRUE, FALSE, TRUE, FALSE),
(13, FALSE, FALSE, TRUE, FALSE, TRUE),
(14, TRUE, FALSE, FALSE, FALSE, FALSE),
(15, FALSE, TRUE, TRUE, TRUE, TRUE),
(16, TRUE, TRUE, TRUE, TRUE, FALSE),
(17, FALSE, FALSE, FALSE, FALSE, TRUE),
(18, TRUE, FALSE, TRUE, TRUE, FALSE),
(19, FALSE, TRUE, FALSE, TRUE, TRUE),
(20, TRUE, FALSE, FALSE, FALSE, FALSE);


-- 10 Values for property table
INSERT INTO property (property_id, property_name, property_type, number_of_rooms, price_per_night) VALUES
(1, 'Sunny Apartment', 'Apartment', 3, 120.00),
(2, 'Cozy Villa', 'Villa', 5, 250.00),
(3, 'Urban Room', 'Room', 1, 75.00),
(4, 'Lakeview Apartment', 'Apartment', 2, 150.00),
(5, 'Mountain Villa', 'Villa', 4, 200.00),
(6, 'Downtown Room', 'Room', 1, 80.00),
(7, 'Seaside Apartment', 'Apartment', 3, 180.00),
(8, 'Countryside Villa', 'Villa', 5, 220.00),
(9, 'City Center Room', 'Room', 1, 90.00),
(10, 'Beachfront Apartment', 'Apartment', 2, 160.00),
(11, 'Luxury Villa', 'Villa', 4, 300.00),
(12, 'Studio Room', 'Room', 1, 70.00),
(13, 'Penthouse Apartment', 'Apartment', 3, 250.00),
(14, 'Classic Villa', 'Villa', 4, 210.00),
(15, 'Budget Room', 'Room', 1, 65.00),
(16, 'Modern Apartment', 'Apartment', 2, 140.00),
(17, 'Rustic Villa', 'Villa', 5, 230.00),
(18, 'Guest Room', 'Room', 1, 85.00),
(19, 'Skyline Apartment', 'Apartment', 3, 190.00),
(20, 'Royal Villa', 'Villa', 6, 300.00);


-- 11 Values for amenities table
INSERT INTO amenities (amenity_id, swimming_pool, breakfast, wi_fi, hot_tub, spa) VALUES
(1, TRUE, TRUE, TRUE, TRUE, TRUE),
(2, FALSE, TRUE, TRUE, FALSE, TRUE),
(3, TRUE, FALSE, TRUE, TRUE, FALSE),
(4, TRUE, TRUE, FALSE, FALSE, TRUE),
(5, FALSE, FALSE, TRUE, TRUE, TRUE),
(6, TRUE, FALSE, FALSE, TRUE, FALSE),
(7, FALSE, TRUE, FALSE, FALSE, TRUE),
(8, TRUE, TRUE, TRUE, FALSE, FALSE),
(9, FALSE, FALSE, FALSE, TRUE, TRUE),
(10, TRUE, FALSE, TRUE, FALSE, TRUE),
(11, FALSE, TRUE, FALSE, TRUE, FALSE),
(12, TRUE, TRUE, FALSE, TRUE, TRUE),
(13, FALSE, FALSE, TRUE, FALSE, FALSE),
(14, TRUE, FALSE, FALSE, FALSE, TRUE),
(15, FALSE, TRUE, TRUE, TRUE, FALSE),
(16, TRUE, TRUE, TRUE, TRUE, FALSE),
(17, FALSE, FALSE, FALSE, FALSE, TRUE),
(18, TRUE, FALSE, TRUE, TRUE, FALSE),
(19, FALSE, TRUE, FALSE, FALSE, FALSE),
(20, TRUE, FALSE, FALSE, TRUE, TRUE);

-- 12 Values  for Location table
INSERT INTO location (location_id, country, state_of_country, city) VALUES
(1, 'Netherlands', 'North Holland', 'Amsterdam'),
(2, 'Netherlands', 'North Holland', 'Haarlem'),
(3, 'Netherlands', 'South Holland', 'Rotterdam'),
(4, 'Netherlands', 'Utrecht', 'Utrecht'),
(5, 'Netherlands', 'North Brabant', 'Eindhoven'),
(6, 'Netherlands', 'Limburg', 'Maastricht'),
(7, 'Netherlands', 'Overijssel', 'Enschede'),
(8, 'Netherlands', 'Gelderland', 'Nijmegen'),
(9, 'Netherlands', 'North Holland', 'Alkmaar'),
(10, 'Netherlands', 'Friesland', 'Leeuwarden'),
(11, 'Brazil', 'São Paulo', 'São Paulo'),
(12, 'Argentina', 'Buenos Aires', 'Buenos Aires'),
(13, 'Chile', 'Santiago Metropolitan', 'Santiago'),
(14, 'Peru', 'Lima Province', 'Lima'),
(15, 'Colombia', 'Bogota D.C', 'Bogota'),
(16, 'France', 'Île-de-France', 'Paris'),
(17, 'Germany', 'Berlin', 'Berlin'),
(18, 'Spain', 'Community of Madrid', 'Madrid'),
(19, 'Italy', 'Lazio', 'Rome'),
(20, 'United Kingdom', 'England', 'London');

-- 13 Values for accommodation table
INSERT INTO accommodation (accommodation_id, property_id, address_id, location_id, amenity_id, rules_id, host_id) VALUES
(1, 1, 1, 1, 1, 4, 1),
(2, 2, 2, 2, 1, 4, 2),
(3, 3, 3, 2, 1, 4, 3),
(4, 4, 4, 2, 2, 1, 4),
(5, 5, 5, 3, 3, 2, 5),
(6, 6, 6, 4, 3, 3, 6),
(7, 7, 7, 5, 4, 4, 7),
(8, 8, 8, 6, 5, 5, 8),
(9, 9, 9, 7, 6, 6, 9),
(10, 10, 10, 10, 6, 7, 10),
(11, 11, 11, 11, 7, 10, 11),
(12, 12, 12, 12, 17, 13, 12),
(13, 13, 13, 13, 9, 18, 13),
(14, 14, 14, 14, 10, 16, 14),
(15, 15, 15, 15, 11, 12, 15),
(16, 16, 16, 16, 12, 5, 16),
(17, 17, 17, 17, 13, 1, 17),
(18, 18, 18, 18, 14, 9, 18),
(19, 19, 19, 19, 15, 4, 19),
(20, 20, 20, 20, 16, 10, 20);

-- 14 Values for Property Review table
INSERT INTO property_review (property_review_id, text_review, location_stars, cleanliness_stars, hospitality_stars)
VALUES
(1, 'Beautiful property with great views. Loved the location!', '5', '4', '5'),
(2, 'Average property, but good value for the price.', '3', '3', '4'),
(3, 'Outstanding property with excellent amenities.', '5', '5', '5'),
(4, 'Not a pleasant experience. Property was dirty.', '2', '1', '2'),
(5, 'Amazing stay with wonderful hospitality.', '4', '5', '5'),
(6, 'Good location and cleanliness. Recommended!', '4', '4', '4'),
(7, 'Terrible property. Stay away from this place.', '1', '1', '1'),
(8, 'Fantastic property for a family vacation.', '5', '5', '4'),
(9, 'Decent property, but could be cleaner.', '3', '2', '3'),
(10, 'Superb experience. Would definitely come back.', '5', '5', '5'),
(11, 'Average stay. Nothing special about the property.', '3', '3', '3'),
(12, 'Lovely property in a quiet neighborhood.', '4', '4', '5'),
(13, 'Disappointing. Property did not meet expectations.', '2', '2', '2'),
(14, 'Great property with friendly hosts. Highly recommended!', '5', '5', '5'),
(15, 'Clean and comfortable property for a short stay.', '4', '4', '4'),
(16, 'Worst experience ever. Avoid at all costs.', '1', '1', '1'),
(17, 'Wonderful property with stunning views.', '5', '4', '5'),
(18, 'Satisfactory stay, but nothing exceptional.', '3', '3', '3'),
(19, 'Excellent property with top-notch amenities.', '5', '5', '5'),
(20, 'Unpleasant stay. Property was not well-maintained.', '2', '1', '2');

-- 15 Values for Accommodation Rating table
INSERT INTO accommodation_rating (accommodation_rating_id, property_id, host_id, guest_id, amenity_id, property_review_id)
VALUES
(1, 3, 3, 2, 1, 1),
(2, 5, 5, 7, 3, 2),
(3, 2, 4, 5, 1, 3),
(4, 7, 7, 1, 4, 4),
(5, 6, 6, 5, 3, 5),
(6, 4, 4, 3, 2, 6),
(7, 1, 1, 2, 1, 7),
(8, 8, 8, 9, 5, 8),
(9, 10, 10, 5, 6, 9),
(10, 9, 9, 4, 6, 10),
(11, 11, 11, 2, 7, 11),
(12, 12, 12, 9, 17, 12),
(13, 2, 2, 1, 1, 13),
(14, 3, 3, 7, 1, 14),
(15, 7, 7, 5, 4, 15),
(16, 6, 6, 8, 3, 16),
(17, 10, 10, 3, 6, 17),
(18, 4, 4, 10, 2, 18),
(19, 9, 9, 8, 6, 19),
(20, 5, 5, 7, 3, 20);

-- 16 Values for Transaction table
INSERT INTO transaction (transaction_id, transaction_number, amount)
VALUES
(1, 'TXN12345', 1187.50),
(2, 'TXN23456', 712.50),
(3, 'TXN34567', 380.00),
(4, 'TXN45678', 1463.00),
(5, 'TXN56789', 1064.00),
(6, 'TXN67890', 266.00),
(7, 'TXN78901', 1396.50),
(8, 'TXN89012', 931.00),
(9, 'TXN90123', 403.75),
(10, 'TXN01234', 2565.00),
(11, 'TXN12345', 798.00),
(12, 'TXN23456', 356.25),
(13, 'TXN34567', 1330.00),
(14, 'TXN45678', 684.00),
(15, 'TXN56789', 598.50),
(16, 'TXN67890', 1995.00),
(17, 'TXN78901', 1187.50),
(18, 'TXN89012', 555.75),
(19, 'TXN90123', 1092.50),
(20, 'TXN01234', 902.50);


-- 16 Values for Date table
INSERT INTO date (date_id, actual_date, "year", "month", is_weekend)
VALUES
(1, '2023-01-01', 2023, 1, true),
(2, '2023-02-15', 2023, 2, false),
(3, '2023-03-20', 2023, 3, false),
(4, '2023-04-10', 2023, 4, false),
(5, '2023-01-05', 2023, 5, false),
(6, '2023-01-18', 2023, 6, true),
(7, '2023-05-30', 2023, 7, true),
(8, '2023-08-22', 2023, 8, false),
(9, '2023-02-12', 2023, 9, false),
(10, '2023-05-05', 2023, 10, false),
(11, '2023-11-11', 2023, 11, false),
(12, '2023-12-25', 2023, 12, true),
(13, '2023-01-01', 2023, 1, true),
(14, '2023-02-14', 2023, 2, false),
(15, '2023-03-19', 2023, 3, false),
(16, '2023-04-09', 2023, 4, false),
(17, '2023-02-04', 2023, 5, false),
(18, '2023-05-17', 2023, 6, true),
(19, '2023-07-29', 2023, 7, true),
(20, '2023-08-21', 2023, 8, false);

-- 17 Values for Special Offer table
INSERT INTO special_offer (offer_id, code, description, start_date, end_date)
VALUES
(1, 'SPR2023', 'Spring Discount 2023 (5% off)', '2023-03-01', '2023-04-30'),
(2, 'SUM2023', 'Summer Promotion 2023 (5% off)', '2023-06-01', '2023-08-31'),
(3, 'FALL2023', 'Fall Getaway 2023 (5% off)', '2023-09-01', '2023-11-30'),
(4, 'WINTER2023', 'Winter Retreat 2023 (5% off)', '2023-12-01', '2024-02-28'),
(5, 'EARLYBIRD', 'Early Bird Booking 2024 (5% off)', '2024-01-15', '2024-04-15'),
(6, 'VALENTINE', 'Valentine''s Day Special 2024 (5% off)', '2024-02-01', '2024-02-14'),
(7, 'EASTER', 'Easter Weekend Offer 2024 (5% off)', '2024-04-10', '2024-04-12'),
(8, 'SUMMER', 'Summer Break 2024 (5% off)', '2024-06-01', '2024-08-31'),
(9, 'FALL', 'Autumn Escape 2024 (5% off)', '2024-09-01', '2024-11-30'),
(10, 'HOLIDAYS', 'Holiday Season 2024 (5% off)', '2024-12-15', '2025-01-02'),
(11, 'SPR', 'Spring Retreat 2025 (5% off)', '2025-03-01', '2025-04-30'),
(12, 'SUMMER', 'Summer Paradise 2025 (5% off)', '2025-06-01', '2025-08-31'),
(13, 'WINTER', 'Winter Wonderland 2025 (5% off)', '2025-12-01', '2026-02-28'),
(14, 'NEWYEAR', 'New Year''s Celebration 2026 (5% off)', '2025-12-31', '2026-01-02'),
(15, 'VALENTINE', 'Valentine''s Day Escape 2026 (5% off)', '2026-02-01', '2026-02-14'),
(16, 'EASTER', 'Easter Getaway 2026 (5% off)', '2026-04-03', '2026-04-05'),
(17, 'SUMMER', 'Summer Adventure 2026 (5% off)', '2026-06-01', '2026-08-31'),
(18, 'FALL', 'Autumn Bliss 2026 (5% off)', '2026-09-01', '2026-11-30'),
(19, 'HOLIDAYS', 'Holiday Magic 2026 (5% off)', '2026-12-15', '2027-01-02'),
(20, 'SPR', 'Spring Serenity 2027 (5% off)', '2027-03-01', '2027-04-30');


-- 19 Values for income_calculator table
INSERT INTO income_calculator (calculation_id, property_id, host_id, amenity_id, location_id,
 host_income_per_day, website_income_per_day, guest_commission, host_commission)
VALUES
(1, 1, 1, 1, 1, 108.00, 18.00, 0.05, 0.1),
(2, 2, 2, 1, 2, 225.00, 37.50, 0.05, 0.1),
(3, 3, 3, 1, 2, 67.50, 11.25, 0.05, 0.1),
(4, 4, 4, 2, 2, 135.00, 22.50, 0.05, 0.1),
(5, 5, 5, 3, 3, 180.00, 30.00, 0.05, 0.1),
(6, 6, 6, 3, 4, 72.00, 12.00, 0.05, 0.1),
(7, 7, 7, 4, 5, 162.00, 27.00, 0.05, 0.1),
(8, 8, 8, 5, 6, 198.00, 33.00, 0.05, 0.1),
(9, 9, 9, 6, 7, 81.00, 13.50, 0.05, 0.1),
(10, 10, 10, 6, 10, 144.00, 24.00, 0.05, 0.1),
(11, 11, 11, 7, 11, 270.00, 45.00, 0.05, 0.1),
(12, 12, 12, 17, 12, 63.00, 10.50, 0.05, 0.1),
(13, 13, 13, 9, 13, 225.00, 37.50, 0.05, 0.1),
(14, 14, 14, 10, 14, 189.00, 31.50, 0.05, 0.1),
(15, 15, 15, 11, 15, 58.50, 9.75, 0.05, 0.1),
(16, 16, 16, 12, 16, 126.00, 21.00, 0.05, 0.1),
(17, 17, 17, 13, 17, 207.00, 34.50, 0.05, 0.1),
(18, 18, 18, 14, 18, 76.50, 12.75, 0.05, 0.1),
(19, 19, 19, 15, 19, 171.00, 28.50, 0.05, 0.1),
(20, 20, 20, 16, 20, 270.00, 45.00, 0.05, 0.1);


-- 20 Values for Booking table
INSERT INTO booking (booking_id, guest_id, host_id, property_id, date_id, transaction_id, offer_id, booking_status, stay_reason, check_in_date, check_out_date)
VALUES
(1, 1, 2, 2, 1, 1, 1, 'Confirmed', 'Vacation', '2023-03-15', '2023-03-20'),
(2, 3, 4, 4, 2, 2, 2, 'Confirmed', 'Work', '2023-06-10', '2023-06-15'),
(3, 5, 6, 6, 3, 3, 3, 'On hold', 'Study', '2023-09-05', '2023-09-10'),
(4, 7, 8, 8, 4, 4, 4, 'Canceled', 'Vacation', '2023-12-20', '2023-12-27'),
(5, 9, 10, 10, 5, 5, 5, 'Confirmed', 'Work', '2024-02-14', '2024-02-21'),
(6, 11, 12, 12, 6, 6, 6, 'Confirmed', 'Vacation', '2024-04-01', '2024-04-05'),
(7, 13, 14, 14, 7, 7, 1, 'Confirmed', 'Study', '2024-06-18', '2024-06-25'),
(8, 15, 16, 16, 8, 8, 2, 'On hold', 'Work', '2024-12-24', '2024-12-31'),
(9, 17, 18, 18, 9, 9, 3, 'Confirmed', 'Vacation', '2025-03-10', '2025-03-15'),
(10, 19, 20, 20, 10, 10, 4, 'Confirmed', 'Work', '2025-06-01', '2025-06-10'),
(11, 2, 1, 1, 11, 11, 5, 'On hold', 'Study', '2025-12-23', '2025-12-30'),
(12, 4, 3, 3, 12, 12, 6, 'Canceled', 'Vacation', '2025-12-31', '2026-01-05'),
(13, 6, 5, 5, 13, 13, 1, 'Confirmed', 'Study', '2026-02-14', '2026-02-21'),
(14, 8, 7, 7, 14, 14, 2, 'Confirmed', 'Work', '2026-04-01', '2026-04-05'),
(15, 10, 9, 9, 15, 15, 3, 'Confirmed', 'Vacation', '2026-06-18', '2026-06-25'),
(16, 12, 11, 11, 16, 16, 4, 'On hold', 'Study', '2026-12-24', '2026-12-31'),
(17, 14, 13, 13, 17, 17, 5, 'Confirmed', 'Vacation', '2027-03-10', '2027-03-15'),
(18, 16, 15, 15, 18, 18, 6, 'Confirmed', 'Work', '2027-06-01', '2027-06-10'),
(19, 18, 17, 17, 19, 19, 1, 'Confirmed', 'Work', '2027-08-15', '2027-08-20'),
(20, 20, 19, 19, 20, 20, 2, 'Confirmed', 'Vacation', '2027-09-05', '2027-09-10');















































