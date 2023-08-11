import pymysql
import streamlit as st
import pandas as pd

mydb = pymysql.connect(host="localhost", user="root", password="", db="placements")

st.title("Placement Management System")
with mydb.cursor() as cursor:
    col1, col2 = st.columns(2)
    with st.container():
        with col1:
            st.title("Insert into company")
            with st.form("Company form", clear_on_submit=True):
                cid = st.text_input("Company_ID")
                name = st.text_input("Name")
                phone = st.text_input("Phone_No")
                web = st.text_input("Website")
                ctype = st.text_input("Company_Type")
                add = st.text_input("Address")
                
                button = st.form_submit_button("Submit")
                if button:
                    cursor.execute("INSERT INTO company VALUES(%s,%s,%s,%s,%s,%s)", (cid,name,phone,web,ctype,add,))
                    mydb.commit()
                    st.success("Record Inserted!")
        with col2:
            st.title("display company details")
            with st.form("Search company details", clear_on_submit=True):
                name = st.text_input("company name:")
                button = st.form_submit_button("Search")
                if button:
                    cursor.execute("SELECT * FROM company WHERE name=%s", (name,))
                    res = cursor.fetchone()
                    if res:
                        st.table(pd.DataFrame(res))
                    else:
                        st.error("company details not found")       
