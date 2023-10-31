create database AB104
use AB104

create table Genders(
Id int primary key identity,
Gender nvarchar(32))


insert into Genders values ('Male'),('Female')

create table Users(
Id int primary key identity,
Name varchar(32) not null,
Username varchar(32) unique not null,
Password varchar(64) not null,
GenderId int foreign key references Genders(Id))

insert into Users values ('Asiman','asmannn18','asiman1234',1),('Zulfiyye','zuzu','zuzu1234',2),('Sabuhi','fenerli','fener1234',1)
 

create table Artists(
Id int primary key identity,
Name nvarchar(64) not null,
Surname nvarchar(64) not null,
Birthday datetime2 not null,
GenderId int foreign key references Genders(Id))


insert into Artists values ('Shamama','Khuliyeva','10.02.2003',2),('Rashad','XXX','11.04.2004',1)

create table Categories(
Id int primary key identity,
Name nvarchar(32) not null)

insert into Categories values ('Rock'),('Retro'),('Pop'),('Slow')


create table Musics(
Id int primary key identity,
Name nvarchar(128) not null,
Duration int check (Duration>0),
CategoryId int foreign key references Categories(Id))

insert into Musics values ('Naxcivanda bizimdi',240,3),('Another Love',180,4)

create table MusicArtist(
MusicId int foreign key references Musics(Id),
ArtistId int foreign key references Artists(Id))

insert into MusicArtist values (1,1),(2,2)


create table UserMusics(
UserId int foreign key references Users(Id),
MusicId int foreign key references Musics(Id))

insert into UserMusics values (1,1),(2,2)

create view MusicLibary
as
select m.Name Music,m.Duration,c.Name Category,a.Name+' '+a.Surname Artist from Musics m
join Categories c
on m.CategoryId=c.Id
join MusicArtist ma
on m.Id=ma.MusicId
join Artists a
on ma.ArtistId=a.Id

 select*from MusicLibary

 create view UserPlaylist
 as
 select u.Id, u.Username,m.Name from UserMusics um
 join Users u
 on um.UserId=u.Id
 join Musics m
 on um.MusicId=m.Id

 select*from UserPlaylist
