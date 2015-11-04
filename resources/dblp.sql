CREATE DATABASE IF NOT EXISTS dblp;
USE dblp;

DROP TABLE IF EXISTS `author`;

CREATE TABLE `author` (
`name` varchar(100) DEFAULT NULL,
`paper_key` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

create index author_index on author (`name`, `paper_key`);

DROP TABLE IF EXISTS `citation`;
CREATE TABLE `citation` (
`paper_cite_key` varchar(200) DEFAULT NULL,
`paper_cited_key` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

create index citation_index on citation (`paper_cite_key`, `paper_cited_key`);

DROP TABLE IF EXISTS `conference`;
CREATE TABLE `conference` (
`conf_key` varchar(100) DEFAULT NULL,
`name` text,
`detail` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
create index conference_index on citation (`conf_key`);

DROP TABLE IF EXISTS `paper`;
CREATE TABLE `paper` (
`title` text,
`year` int(11) DEFAULT '0',
`conference` text,
`paper_key` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

create index paper_index on citation (`paper_key`);

DROP TABLE IF EXISTS `author_md5`;
CREATE TABLE `author_md5` (
  `md5` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into dblp.author_md5(`md5`, `name`) 
select distinct md5(`name`) as `md5`, `name` 
from dblp.author;

DROP TABLE IF EXISTS `author_paper`;
CREATE TABLE `author_paper` (
  `author_md5` varchar(100) NOT NULL,
  `paper_key_md5` varchar(100) NOT NULL,
  PRIMARY KEY (`author_md5`,`paper_key_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into dblp.author_paper(`author_md5`,`paper_key_md5`) 
select distinct
	md5(`name`) as `author_md5`, 
    md5(`paper_key`) as `paper_key_md5` 
from dblp.author;

CREATE TABLE `dataset_md5` (
  `author` varchar(100) NOT NULL,
  `paper_key` varchar(100) NOT NULL,
  `conference` varchar(100),
  `year` int,
  `title` text,
  PRIMARY KEY (`author`,`paper_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into dblp.dataset_md5(`author`,`paper_key`,`conference`, `year`, `title`) 
select distinct md5(a.`name`) as `author`, 
	md5(a.`paper_key`) as `paper_key`, 
	md5(p.`conference`) as `conference`,
    p.year,
    p.title
from dblp.author a
inner join dblp.paper p
on a.paper_key = p.paper_key and p.year > 2004


DROP TABLE IF EXISTS `author_paper_author`;
CREATE TABLE `author_paper_author` (
  `author1` varchar(100) NOT NULL,
  `paper` varchar(100) NOT NULL,
  `author2` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

create index author_paper_author_index on author_paper_author (`author1`,`paper`,`author2`);

insert into dblp.author_paper_author(`author1`, `paper`,`author2`) 
SELECT a.author_md5 as author1, a.paper_key_md5 as paper, b.author_md5 as author2 
FROM dblp.author_paper a 
inner join  dblp.author_paper b 
on a.paper_key_md5 = b.paper_key_md5 
and a.author_md5 <> b.author_md5 
inner join paper p 
on md5(p.paper_key) = a.paper_key_md5 and p.year >= 2010;

