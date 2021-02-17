--show JG_GPA TABLE
select * from JG_GPA;

--SPEC
create or replace package pkg_jg6254_gpa is
procedure p_run_all;
END;

CREATE or Replace PACKAGE BODY pkg_jg6254_gpa IS
 --Define all local functions/procedures
 -- write function to get letter grade
    function f_get_letter_grade(i_grade_nr number)
    return VARCHAR2
    is 
    v_letter_grade_tx varchar2(1);
    Begin
    --Convert number grade to letter
        if i_grade_nr between 90 and 100 then
            v_letter_grade_tx :='A';
        elsif i_grade_nr between 80 and 90 then
            v_letter_grade_tx :='B';
        elsif i_grade_nr between 70 and 80 then
            v_letter_grade_tx :='C';
        elsif i_grade_nr between 70 and 80 then
            v_letter_grade_tx :='D';
        else
            v_letter_grade_tx :='F';
        end if;
    return v_letter_grade_tx;
    END;

 -- write function to get the point grade
function f_get_course_point_nr(i_grade_nr number)
return VARCHAR2
is 
v_course_point_nr number; 
Begin
    --Convert number grade to points
    if i_grade_nr between 90 and 100 then
        v_course_point_nr :=4;    
    elsif i_grade_nr between 80 and 90 then
        v_course_point_nr :=3; 
    elsif i_grade_nr between 70 and 80 then
        v_course_point_nr :=2; 
    elsif i_grade_nr between 70 and 80 then
        v_course_point_nr :=1; 
    else
        v_course_point_nr :=0; 
    end if;
return v_course_point_nr;
END;

---write a function to get total credit hours for this semester
function f_get_total_hour_nr
return number 
is 
cursor cur_all is select * from JG_GPA;
V_total_hour_nr NUMBER;
BEGIN
    V_total_hour_nr :=0;
    for each_subject in cur_all loop
    V_total_hour_nr :=V_total_hour_nr +each_subject.credit_hour;
    END LOOP;
return V_total_hour_nr;
END; 



---write a function to get total credit numbers for this semester
function f_get_total_credit_nr
return number
is 
cursor cur_all is select * from JG_GPA;
v_total_credit_nr number; 
BEGIN
    v_total_credit_nr :=0;
    for each_subject in cur_all loop
    v_total_credit_nr :=v_total_credit_nr+f_get_course_point_nr(each_subject.num_grade)*each_subject.credit_hour;
    END LOOP;
return v_total_credit_nr;
END;   

  

----write function to get GPA
function f_get_GPA
return number
is 
V_GPA_NR NUMBER;
BEGIN
    V_GPA_NR :=round(f_get_total_credit_nr/f_get_total_hour_nr,2);      
return V_GPA_NR;
END;  

---write a procedure to get the report card
procedure p_run_all is
    cursor cur_all is select * from JG_GPA;
    begin
        dbms_output.put_line('************ Report Card *******************');
        dbms_output.put_line(rpad('Course',20)||rpad('Hours',10)||rpad('Grade',10));
        for each_subject in cur_all loop
            dbms_output.put_line(rpad(each_subject.SUBJECT,20)||rpad(each_subject.CREDIT_HOUR,10)||rpad(each_subject.NUM_GRADE,10));
        end loop;
        dbms_output.put_line('GPA    : '||f_get_GPA());
    END;
END;


---call the procedure to get the GPA report
begin
   pkg_jg6254_gpa.p_run_all;
end;

/*


-- call the function to get letter grade
declare
   v_letter_grade_tx varchar2(1);
begin
   -- Call the function
   v_letter_grade_tx := pkg_jg6254_gpa.f_get_letter_grade(90);
   DBMS_OUTPUT.PUT_LINE('letter_grade_tx:'||v_letter_grade_tx);
end;


-- call the function to get point grade
declare
   v_point_grade_tx varchar2(1);
begin
   -- Call the function
   v_point_grade_tx := pkg_jg6254_gpa.f_get_course_point_nr(90);
   DBMS_OUTPUT.PUT_LINE('point_grade_tx:'||v_letter_grade_tx);
end;


*/










 