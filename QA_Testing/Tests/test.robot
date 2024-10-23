*** Settings ***
Library    SeleniumLibrary
Library    ../Libraries/Users.py
Library    Collections
Variables    ../Variables/variable.py
Suite Setup    Launch Browser
# Suite Teardown    Close Browser

*** Variables ***
${remote_url}     http://172.17.0.1:4444
${my_suite_variable}    Suite Variable


*** Test Cases ***

Test Case No 1
    Login User    demo    demo
    Go To Link    Customers
    # Display All Names
    Fetch Data
    Add Users
    Get All Names
    Display All names

Test Case No 2
    Check Orders List Count

*** Keywords ***
Launch Browser
    [Arguments]    ${url}=https://marmelab.com/react-admin-demo/#/login

    Open Browser    ${url}    chrome    remote_url=${remote_url}    options=add_argument("--start-maximized")

Login User
    [Arguments]    ${user}    ${pass}
    Wait Until Element Is Visible    //button
    Input Text    name:username    ${user}
    Input Text    name:password    ${pass}
    Click Button    //*[@id="root"]/form/div/div/div[4]/button

Go To Link
    [Arguments]    ${text}
    Click Element    //a[text()="${text}"]
    Wait Until Element Is Visible    //tbody/tr[last()]

Fetch Data
    ${users}    Get Users Via Api
    ${user_length}  Get Length    ${users}
    Set Suite Variable    ${USERS}    ${users}
    Set Suite Variable  ${USER_LENGTH}    ${user_length}


Count All Rows In Tbody
    ${row_count}=    Get Element Count    //tbody/tr
    Log To Console   Number of rows in tbody: ${row_count}
Open Add Identity Modal
    Click Element    ${create_button}
    Sleep    3s

Add Users
    FOR    ${user}    IN    @{USERS}
        Open Add Identity Modal
        Add User    ${user}
        Go To Link    Customers
    END

Add User
    [Arguments]    ${user}  
    Wait Until Element Is Visible    ${identity_txt_firstname}

    ${firstName}    Evaluate    " ".join("${user['name']}".split()[:-1]).strip()
    ${lastName}    Evaluate    " ".join("${user['name']}".split()[-1:]).strip()

    Input Text    ${identity_txt_firstname}    ${firstName}
    Input Text    ${identity_txt_lastname}     ${lastName}
    Input Text    ${identity_txt_email}     ${user['email']}
    Press Key    ${identity_txt_birthday}    ${user['birthday']}
    Input Text    ${identity_txt_address}    ${user['address']['street']}
    Input Text    ${identity_txt_city}    ${user['address']['city']}
    Input Text    ${identity_txt_state}    ${user['address']['street']}
    Input Text    ${identity_txt_zip}    ${user['address']['zipcode']} 
    Input Text    ${identity_txt_password}    ${user['phone']}
    Input Text    ${identity_txt_confirm_password}    ${user['phone']} 
    Click Element    ${submit_button}

    Sleep    3s

Get All names
    ${Web_Elems}  Get WebElements    //tbody//tr
    ${elems_len}    Get Length    ${Web_Elems}
    Log To Console    ${elems_len}
    ${names_list}  Create List
    
    FOR  ${i}  IN RANGE  1  ${elems_len}+1
        ${locator}  Set Variable  (//tbody//tr[${i}]/td[2])
        ${text}  Get Text  ${locator}
        ${text}  Evaluate   r"""${text}""".replace("\\n", "").strip()[1:]
            

        Append To List  ${names_list}  ${text}
    END
    
    Set Suite Variable  ${NAMES_LIST}  ${names_list}

Display All names
    ${NAMES_LIST_LENGTH}=    Get Length    ${NAMES_LIST}
    ${orders_list}  Create List

    FOR    ${i}    IN RANGE    0    ${NAMES_LIST_LENGTH}
        IF  ${i} == 0
            Log To Console   ${text_divider}
            Log To Console    All Created Users Are Displayed 
            Log To Console   ${text_divider}
        END

        

        IF    ${i} <= ${USER_LENGTH}
            ${header}    Set Variable    Test Created User
        ELSE
            ${header}    Set Variable    Existing User
        END
        ${last_seen}  Get Text    //tbody//tr[${i+1}]//td[3]
        ${orders}    Get Text    //tbody//tr[${i+1}]//td[4]
        ${total_spent}    Get Text    //tbody//tr[${i+1}]//td[5]
        ${lastest_purchase}    Get Text    //tbody//tr[${i+1}]//td[6]
        ${news}    Get Text    //tbody//tr[${i+1}]//td[7]
        ${segment}  Get Text  //tbody//tr[${i+1}]//td[8]
        
        IF  ${orders} == 0
            Append To List    ${orders_list}    ${NAMES_LIST}[${i}]
        END

        Set Suite Variable    ${ORDERS_LIST}    ${orders_list}
        
        
        Log To Console    -------- USER ${i+1} --------
        Log To Console    ${header} : ${NAMES_LIST}[${i}]
        Log To Console    Last Seen : ${last_seen}
        Log To Console    Orders : ${orders}
        Log To Console    Total Spent : ${total_spent}
        Log To Console    Latest Purchase : ${lastest_purchase}
        Log To Console    News : ${news}
        Log To Console    Segment : ${segment}
        Log To Console    ${text_divider}
    END

Check Orders List Count
    ${zero_orders_count}  Get Length  ${ORDERS_LIST}

    IF  ${zero_orders_count} >= 1
        Fail    Users with zero orders found: ${ORDERS_LIST}
    END