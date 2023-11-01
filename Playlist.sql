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
 select u.Id, u.Username,m.Name,a.Name Artist from UserMusics um
 join Users u
 on um.UserId=u.Id
 join Musics m
 on um.MusicId=m.Id
 join MusicArtist ma
 on ma.MusicId=m.Id
 join Artists a
 on ma.ArtistId=a.Id
 

 select*from UserPlaylist



 --------------------------------------------------task 2-----------------------------------------------------



 create procedure usp_CreateMusic @musicName nvarchar(128),@musicDuration int,@categoryId int
 as
 insert into Musics values (@musicName,@musicDuration,@categoryId)


 exec usp_CreateMusic 'semmamme',120,1


 create procedure usp_CreateUser @name  varchar(32),@userName varchar(32),@password varchar(64),@genderId int
 as
 insert into Users values(@name,@userName,@password,@genderId)


 exec usp_CreateUser 'gunel','designer','dombili150',2


 alter table Musics add IsDeleted bit default 0
 
 create trigger delete_music_trigger
 on Musics
instead of delete
as
declare @result bit
declare @id int
select @result=IsDeleted,@id=deleted.Id from deleted
if(@result=0)
 begin
 update Musics set IsDeleted=1 where Id=@id
 end
else
begin
 delete from Musics where Id=@id
 end


 delete from Musics where Id=3




 create function GetUserArtistCountByUserId(@userId int)
 returns int
 begin
 declare @result int
 select @result=COUNT(Artist) from UserPlaylist
 where Id=@userId
 return @result
 end

 select dbo.GetUserArtistCountByUserId(1) as [count]