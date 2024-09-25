ALTER TABLE authors ADD CONSTRAINT unique_author UNIQUE(surname, first_name, second_name);
ALTER TABLE editors ADD CONSTRAINT unique_editor UNIQUE(surname, first_name, second_name);
ALTER TABLE books ADD CONSTRAINT unique_book UNIQUE(title);
ALTER TABLE publishers ADD CONSTRAINT unique_publisher UNIQUE(name);

ALTER TABLE books
ALTER COLUMN title SET NOT NULL,
ALTER COLUMN genre SET NOT NULL,
ALTER COLUMN age_rating SET DEFAULT 0,
ALTER COLUMN pages SET NOT NULL,
ALTER COLUMN annotation SET NOT NULL;

ALTER TABLE books ADD CONSTRAINT books_age_rating_check CHECK(age_rating >= 0 AND age_rating <= 18);


ALTER TABLE authors
ALTER COLUMN surname SET NOT NULL,
ALTER COLUMN first_name SET NOT NULL,
ALTER COLUMN second_name SET NOT NULL,
ALTER COLUMN birth_date SET NOT NULL,
ALTER COLUMN death_date SET DEFAULT NULL,
ALTER COLUMN nationality SET NOT NULL;

ALTER TABLE authors ADD CONSTRAINT date_check CHECK(birth_date < death_date);


ALTER TABLE editors
ALTER COLUMN surname SET NOT NULL,
ALTER COLUMN first_name SET NOT NULL,
ALTER COLUMN second_name SET NOT NULL,
ALTER COLUMN experience SET DEFAULT 0,
ALTER COLUMN genre SET NOT NULL;

ALTER TABLE editors ADD CONSTRAINT experience_check CHECK(experience >= 0);


ALTER TABLE publishers
ALTER COLUMN name SET NOT NULL,
ALTER COLUMN phone SET NOT NULL,
ALTER COLUMN country SET NOT NULL,
ALTER COLUMN foundation_date SET NOT NULL,
ALTER COLUMN address SET NOT NULL;


ALTER TABLE publications
ALTER COLUMN publication_date SET NOT NULL,
ALTER COLUMN circulation SET NOT NULL;

ALTER TABLE publications ADD CONSTRAINT circulation_check CHECK(circulation >= 0);