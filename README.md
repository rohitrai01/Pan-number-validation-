PAN Card Validation System
A comprehensive SQL-based solution for validating Indian Permanent Account Number (PAN) cards. This project includes data cleaning, validation functions, and analysis of PAN card numbers.

📋 Overview
This project provides a complete workflow for:

Cleaning raw PAN card data

Validating PAN numbers against official rules

Identifying invalid, duplicate, and malformed entries

Generating comprehensive validation reports

🎯 Features
Data Cleaning: Handles leading/trailing spaces, case inconsistencies, and empty values

Validation Functions: Custom SQL functions for adjacent character and sequence checks

Regex Validation: Official PAN format validation using regular expressions

Comprehensive Reporting: Summary statistics and status classification

View-Based Access: Easy querying through predefined views

📊 PAN Card Format Rules
A valid Indian PAN card must follow this format:

AAAAA0000A (5 letters + 4 digits + 1 letter)

No consecutive identical characters in first 5 letters

No sequential characters in first 5 letters or next 4 digits

All characters must be uppercase

🛠️ Technical Stack
Database: MySQL

Features Used:

User-Defined Functions (UDFs)

Common Table Expressions (CTEs)

Views

Regular Expressions

Window Functions

📁 Database Schema
Table: pan_data
Column	Type	Description
Pan_numbers	VARCHAR	Raw PAN card numbers
View: view_of_status_of_pan
Column	Type	Description
Pan_numbers	VARCHAR	Cleaned PAN numbers
status	VARCHAR	Validation status ('Valid pan' or 'Invalid pan')
