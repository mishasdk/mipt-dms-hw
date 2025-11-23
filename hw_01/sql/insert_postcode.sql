INSERT INTO postcodes (postcode_id, state, country)
VALUES (:postcode_id, :state, :country)
ON CONFLICT (postcode_id) DO NOTHING;