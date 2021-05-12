-- INSERT INTO `data-warehouse-289815.roles.group_role_id` (group_name, group_id, user_role_id)
-- VALUES ('Regional CC Advising - Boyle Heights', '00G1M000004sJP1UAM', '00E46000000YcNmEAK'),
--  ('Regional CC Advising - Denver', '00G1M000004sLcgUAE', '00E46000000YcO1EAK'),
--  ('Regional CC Advising - Aurora', '00G1M000004s0IhUAI', '00E46000000YcO1EAK')


DELETE FROM `data-warehouse-289815.roles.group_role_id`
WHERE group_name = 'Shared CC Advising - Denver/Aurora'