-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Feb 14, 2025 at 08:37 AM
-- Server version: 5.7.39
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_laws`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_documents`
--

CREATE TABLE `tb_documents` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_files`
--

CREATE TABLE `tb_files` (
  `id` int(11) NOT NULL,
  `sub_code` varchar(50) DEFAULT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_link` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_files`
--

INSERT INTO `tb_files` (`id`, `sub_code`, `file_name`, `file_link`, `created_at`) VALUES
(2, '6111204', 'คู่มืออบรม2', 'https://docs.google.com/document/d/1xIJsH1E8U3LP2EbLS6hz80PX8eD6Zjb5EESdzs0W2tM/edit?usp=sharing', '2025-02-14 08:18:29');

-- --------------------------------------------------------

--
-- Table structure for table `tb_links`
--

CREATE TABLE `tb_links` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_links`
--

INSERT INTO `tb_links` (`id`, `name`, `link_url`, `level`, `parent_id`) VALUES
(1, 'มคอ3', NULL, 1, NULL),
(2, 'วิชา 1', NULL, 2, 1),
(3, 'วิชา 2', NULL, 2, 1),
(4, 'วิชา 3', NULL, 2, 1),
(5, 'เทอม 1/2568', 'https://law.rmu.ac.th/', 3, 2),
(6, 'เทอม 2/2568', 'https://law.rmu.ac.th/', 3, 2),
(7, 'ธงคำตอบข้อสอบเก่า', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tb_news`
--

CREATE TABLE `tb_news` (
  `id` int(11) NOT NULL,
  `topic` varchar(255) NOT NULL,
  `detail` text NOT NULL,
  `author` varchar(100) NOT NULL,
  `img1` varchar(255) DEFAULT NULL,
  `img2` varchar(255) DEFAULT NULL,
  `img3` varchar(255) DEFAULT NULL,
  `img4` varchar(255) DEFAULT NULL,
  `img5` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_student`
--

CREATE TABLE `tb_student` (
  `std_code` varchar(10) NOT NULL,
  `std_name` varchar(255) DEFAULT NULL,
  `email` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `std_school` varchar(255) DEFAULT NULL,
  `regist_date` datetime DEFAULT NULL,
  `faculty` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_student`
--

INSERT INTO `tb_student` (`std_code`, `std_name`, `email`, `password`, `std_school`, `regist_date`, `faculty`, `status`) VALUES
('6850101733', 'นางสาวพนิตา ก้อนสีลา', '6850101733@rmu.ac.th', '6850101733', 'โรงเรียนเสลภูมิพิทยาคม', '2024-11-01 10:28:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101744', 'นายจีรภัทร บาลศรี', '6850101744@rmu.ac.th', '6850101744', 'โรงเรียนคำม่วง', '2024-11-01 12:20:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101773', 'นายพีรภัทร พันโยศรี', '6850101773@rmu.ac.th', '6850101773', 'โรงเรียนวาปีปทุม', '2024-11-01 20:09:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101777', 'นางสาวสกุลรัตน์ เมืองซอง', '6850101777@rmu.ac.th', '6850101777', 'โรงเรียนกุฉินารายณ์', '2024-11-01 20:43:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101779', 'นายภัทรธร อึ้งสำราญ', '6850101779@rmu.ac.th', '6850101779', 'โรงเรียนเสลภูมิพิทยาคม', '2024-11-01 20:51:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101783', 'นายอนุชิต ไกรสูนย์', '6850101783@rmu.ac.th', '6850101783', 'โรงเรียนโพนทองพัฒนาวิทยา', '2024-11-01 21:48:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101785', 'นางสาวหทัยชนก เดชสุทธิ์', '6850101785@rmu.ac.th', '6850101785', 'โรงเรียนหนองคายวิทยาคาร', '2024-11-01 22:33:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101790', 'นายพิพัฒน์ ประวะเสนัง', '6850101790@rmu.ac.th', '6850101790', 'โรงเรียนเสือโก้กวิทยาสรรค์', '2024-11-02 07:26:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101793', 'นางสาวชลนิชา ปะระขา ปะระขา', '6850101793@rmu.ac.th', '6850101793', 'โรงเรียนนาเชือกพิทยาสรรค์', '2024-11-02 09:48:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101812', 'นางสาวอิสริยาภรณ์ โสสุด', '6850101812@rmu.ac.th', '6850101812', 'โรงเรียนเสลภูมิพิทยาคม', '2024-11-02 18:43:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101831', 'นางสาวปวริศา ปิดตังถาโน', '6850101831@rmu.ac.th', '6850101831', 'โรงเรียนนาเชือกพิทยาสรรค์', '2024-11-03 15:46:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101860', 'นางสาวอภิญญา แขมโคตร', '6850101860@rmu.ac.th', '6850101860', 'โรงเรียนเหมืองแบ่งวิทยาคม', '2024-11-04 12:43:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101878', 'นางสาวเกวริน สุขบาล', '6850101878@rmu.ac.th', '6850101878', 'โรงเรียนสิรินธรวิทยานุสรณ์', '2024-11-04 20:04:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101886', 'นายณัฐชนน เพ็งพันธ์', '6850101886@rmu.ac.th', '6850101886', 'โรงเรียนโพนทองพัฒนาวิทยา', '2024-11-05 09:26:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101918', 'นางสาวศุภัชญา งามขำ', '6850101918@rmu.ac.th', '6850101918', 'โรงเรียนหนองเรือวิทยา', '2024-11-05 17:33:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101933', 'นางสาวสัตตบงกช ไมขุนทด', '6850101933@rmu.ac.th', '6850101933', 'โรงเรียนบัวเชดวิทยา', '2024-11-06 06:52:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850101940', 'นางสาวปนัดดา ตติยะรัตน์', '6850101940@rmu.ac.th', '6850101940', 'โรงเรียนเมืองกาฬสินธุ์', '2024-11-06 09:57:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850101992', 'นางสาวสิริเพ็ญ ภูทำมา', '6850101992@rmu.ac.th', '6850101992', 'โรงเรียนยางตลาดวิทยาคาร', '2024-11-07 08:53:00', 'น.บ.นิติศาสตร์', 'ผู้สมัคร'),
('6850102102', 'นางสาวชนิสรา ชินโฮง', '6850102102@rmu.ac.th', '6850102102', 'โรงเรียนผดุงนารี', '2024-11-10 00:14:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว'),
('6850102108', 'นายรุ่งโรจน์ ชมภูทิพย์', '6850102108@rmu.ac.th', '6850102108', 'โรงเรียนบัวขาว', '2024-11-10 12:35:00', 'น.บ.นิติศาสตร์', 'ชำระเงินแล้ว');

-- --------------------------------------------------------

--
-- Table structure for table `tb_subject`
--

CREATE TABLE `tb_subject` (
  `id` int(11) NOT NULL,
  `sub_code` varchar(10) NOT NULL,
  `sub_name` varchar(255) NOT NULL,
  `sub_program` varchar(255) DEFAULT NULL,
  `sub_unit` int(11) NOT NULL,
  `sub_term` varchar(20) NOT NULL,
  `sub_teacher` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_subject`
--

INSERT INTO `tb_subject` (`id`, `sub_code`, `sub_name`, `sub_program`, `sub_unit`, `sub_term`, `sub_teacher`) VALUES
(8, '6111204', 'Criminal Law 3', '', 3, '1/2568', 'อ.นิติศาสตร์'),
(9, '6111205	', 'กฎหมายว่าด้วยการกู้ยืมและหลักประกัน', '', 3, '2/2567', 'อ.นิติศาสตร์'),
(15, '6111307', 'หลักกฎหมายระหว่างประเทศ', '', 3, '2/2567', 'อ.นิติศาสตร์');

-- --------------------------------------------------------

--
-- Table structure for table `tb_subject_list`
--

CREATE TABLE `tb_subject_list` (
  `id` int(11) NOT NULL,
  `sub_code` varchar(10) NOT NULL,
  `std_code` varchar(10) NOT NULL,
  `std_name` varchar(100) NOT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_subject_list`
--

INSERT INTO `tb_subject_list` (`id`, `sub_code`, `std_code`, `std_name`, `status`) VALUES
(2, '123456789', '6850101790', '', 'inactive'),
(4, '123456789', '6850101744', '', 'active'),
(5, '123456789', '6850101779', '', 'active'),
(6, '123456789', '6850101785', '', 'active'),
(7, '22222222', '6850101733', '', 'active'),
(8, '22222222', '6850101744', 'นายจีรภัทร บาลศรี', 'active'),
(9, '3333333', '6850101773', 'นายพีรภัทร พันโยศรี', 'active'),
(10, '3333333', '6850101733', 'นางสาวพนิตา ก้อนสีลา', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `tb_user`
--

CREATE TABLE `tb_user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_user`
--

INSERT INTO `tb_user` (`id`, `username`, `password`, `role`) VALUES
(1, 'admin', '2625428', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `tb_vdo`
--

CREATE TABLE `tb_vdo` (
  `id` int(11) NOT NULL,
  `sub_code` varchar(10) NOT NULL,
  `vdo_name` varchar(255) NOT NULL,
  `vdo_link` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_vdo`
--

INSERT INTO `tb_vdo` (`id`, `sub_code`, `vdo_name`, `vdo_link`, `created_at`) VALUES
(8, '6111204', 'vdo youtube', 'https://www.youtube.com/watch?v=brgRLvz6y-I', '2025-02-14 08:37:27');

-- --------------------------------------------------------

--
-- Table structure for table `tb_vdo_views`
--

CREATE TABLE `tb_vdo_views` (
  `id` int(11) NOT NULL,
  `vdo_id` int(11) DEFAULT NULL,
  `std_code` int(11) DEFAULT NULL,
  `view_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_documents`
--
ALTER TABLE `tb_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `tb_files`
--
ALTER TABLE `tb_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_code` (`sub_code`);

--
-- Indexes for table `tb_links`
--
ALTER TABLE `tb_links`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_news`
--
ALTER TABLE `tb_news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_student`
--
ALTER TABLE `tb_student`
  ADD PRIMARY KEY (`std_code`);

--
-- Indexes for table `tb_subject`
--
ALTER TABLE `tb_subject`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sub_code` (`sub_code`);

--
-- Indexes for table `tb_subject_list`
--
ALTER TABLE `tb_subject_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_code` (`sub_code`),
  ADD KEY `std_code` (`std_code`);

--
-- Indexes for table `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_vdo`
--
ALTER TABLE `tb_vdo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_code` (`sub_code`);

--
-- Indexes for table `tb_vdo_views`
--
ALTER TABLE `tb_vdo_views`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vdo_id` (`vdo_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_documents`
--
ALTER TABLE `tb_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_files`
--
ALTER TABLE `tb_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_links`
--
ALTER TABLE `tb_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tb_news`
--
ALTER TABLE `tb_news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_subject`
--
ALTER TABLE `tb_subject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tb_subject_list`
--
ALTER TABLE `tb_subject_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tb_vdo`
--
ALTER TABLE `tb_vdo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tb_vdo_views`
--
ALTER TABLE `tb_vdo_views`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_documents`
--
ALTER TABLE `tb_documents`
  ADD CONSTRAINT `tb_documents_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `tb_vdo` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tb_files`
--
ALTER TABLE `tb_files`
  ADD CONSTRAINT `tb_files_ibfk_1` FOREIGN KEY (`sub_code`) REFERENCES `tb_subject` (`sub_code`) ON DELETE CASCADE;

--
-- Constraints for table `tb_subject_list`
--
ALTER TABLE `tb_subject_list`
  ADD CONSTRAINT `tb_subject_list_ibfk_2` FOREIGN KEY (`std_code`) REFERENCES `tb_student` (`std_code`);

--
-- Constraints for table `tb_vdo`
--
ALTER TABLE `tb_vdo`
  ADD CONSTRAINT `tb_vdo_ibfk_1` FOREIGN KEY (`sub_code`) REFERENCES `tb_subject` (`sub_code`) ON DELETE CASCADE;

--
-- Constraints for table `tb_vdo_views`
--
ALTER TABLE `tb_vdo_views`
  ADD CONSTRAINT `tb_vdo_views_ibfk_1` FOREIGN KEY (`vdo_id`) REFERENCES `tb_vdo` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
