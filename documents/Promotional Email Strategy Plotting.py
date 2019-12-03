#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  2 16:02:14 2019

@author: karen
"""

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt


df = pd.read_excel("/Users/karen/Documents/Gartner/Case Study Email Data_Karen Hong.xlsx", sheet_name = "EDataSourceCampaigns (copy)")

df_email_subject_category= pd.read_excel("/Users/karen/Documents/Gartner/Case Study Email Data_Karen Hong.xlsx", sheet_name = "Email Subject Category")
df_new = df.join(df_email_subject_category.set_index("email subject"), on="email subject")

#plot all emails (regardless of brand names) by its subject content
sns.boxplot(x="Category", y ="read rate percentage (%)", data= df_new.dropna(subset =["read rate percentage (%)"], axis = 0))
#plot all emails of each brand by its subject content
sns.boxplot(x="Category", y ="read rate percentage (%)", data= df_new[df["brand name"]=="ASOS"].dropna(subset =["read rate percentage (%)"], axis = 0))

df_new = df.join(df_email_subject_category.set_index("email subject"), on="email subject")
sns.boxplot(x="Category", y ="read rate percentage (%)", hue = "personalized",data= df_new.dropna(subset =["read rate percentage (%)"], axis = 0), order = ["Account & Order","VIP Offers","Promotional Offers","Trend & Collection Update","Others"])
#botplox with "hue"
sns.boxplot(x="brand name", y ="read rate percentage (%)", hue = "personalized", data= df_new.dropna(subset =["read rate percentage (%)"], axis = 0), order = ["ASOS","Bath & Body Works","Gap","Sephora","Victoria's Secret"])

sns.boxplot(x="brand name", y ="read rate percentage (%)", hue = "personalized", data= df_new.dropna(subset =["read rate percentage (%)"], axis = 0), dodge = True)

not_order = df_new["Category"] != "Account & Order"
sns.boxplot(x="brand name", y ="read rate percentage (%)", hue = "personalized", data= df_new[not_order].dropna(subset =["read rate percentage (%)"], axis = 0), dodge = True)

sns.boxplot(x="brand name", y ="read rate percentage (%)", hue = "Category", data= df_new[not_order].dropna(subset =["read rate percentage (%)"], axis = 0), dodge = True, hue_order = ["VIP Offers","Promotional Offers","Trend & Collection Update","Others"], palette="RdBu",order = ["ASOS","Bath & Body Works","Gap","Sephora","Victoria's Secret"])

df_new[not_order].dropna(subset =["read rate percentage (%)"], axis = 0)[["brand name","Category","read rate percentage (%)"]].groupby(["brand name","Category"]).mean()

#rename column name 'read rate percentage (%)' to 'Read Rate'
df_new.rename(columns={'read rate percentage (%)':'Read Rate'}, inplace=True)

#count ASOS by email category
df_new[not_order][df_new["brand name"]=="ASOS"]["Category"].value_counts()
sns.boxplot(x="Category", y ="Read Rate", data= df_new.dropna(subset =["Read Rate"], axis = 0))

#barplot
df_bar =df_new[not_order].dropna(subset =["Read Rate"], axis = 0)[["brand name","percentage of list"]].groupby("brand name", as_index =False).count()
df_bar.rename(columns={"percentage of list": 'Average "percentage of list"'})