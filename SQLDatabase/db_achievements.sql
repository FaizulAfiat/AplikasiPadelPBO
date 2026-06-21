-- Execute this script in your MySQL database `aplikasi_padel`

-- Create achievements table
CREATE TABLE IF NOT EXISTS `achievements` (
  `achievement_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `icon` varchar(50) NOT NULL,
  `badge_color` varchar(20) NOT NULL,
  `milestone_type` varchar(50) NOT NULL,
  `milestone_value` int(11) NOT NULL,
  PRIMARY KEY (`achievement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert default achievements
INSERT INTO `achievements` (`achievement_id`, `name`, `description`, `icon`, `badge_color`, `milestone_type`, `milestone_value`) VALUES
(1, 'First Booking', 'Make your first booking', '🎾', 'blue', 'booking', 1),
(2, 'Court Regular', 'Make 5 bookings', '🔥', 'green', 'booking', 5),
(3, 'Booking Master', 'Make 20 bookings', '👑', 'gold', 'booking', 20),
(4, 'Community Starter', 'Create 1 community', '🤝', 'purple', 'community_created', 1),
(5, 'Social Player', 'Join 3 communities', '💬', 'pink', 'community', 3),
(6, 'Popular Member', 'Join 5 communities', '🌟', 'orange', 'community', 5),
(9, 'Premium Player', 'Become a premium member', '💎', 'cyan', 'premium', 1),
(10, 'Booking Legend', 'Make 50 bookings', '🏆', 'indigo', 'booking', 50),
(11, 'Padel God', 'Make 100 bookings', '⚡', 'red', 'booking', 100),
(12, 'Community Builder', 'Create 3 communities', '🏗️', 'teal', 'community_created', 3),
(13, 'Community Mogul', 'Create 5 communities', '🏢', 'yellow', 'community_created', 5),
(14, 'Squad Leader', 'Join 10 communities', '🦅', 'emerald', 'community', 10)
ON DUPLICATE KEY UPDATE 
name=VALUES(name), description=VALUES(description), icon=VALUES(icon), badge_color=VALUES(badge_color), milestone_type=VALUES(milestone_type), milestone_value=VALUES(milestone_value);

-- Create user_achievements table
CREATE TABLE IF NOT EXISTS `user_achievements` (
  `user_achievement_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `achievement_id` int(11) NOT NULL,
  `unlocked_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_achievement_id`),
  UNIQUE KEY `user_achievement_unique` (`user_id`,`achievement_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`achievement_id`) REFERENCES `achievements`(`achievement_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
