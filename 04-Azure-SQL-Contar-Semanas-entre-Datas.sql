declare @dt1 datetime = '2022-07-02'
declare @dt2 datetime = '2022-12-31'
select ceiling(convert(float, abs(datediff(day, @dt1, @dt2))) / 7)


select datediff(wk, @dt1, @dt2)