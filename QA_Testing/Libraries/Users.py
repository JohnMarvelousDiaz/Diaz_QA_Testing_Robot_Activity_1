import requests, random
from datetime import datetime, timedelta

class Users():

    def get_users_via_api(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=False)
    
        users = response.json() 

        for user in users:
            random_days = random.randint(0, 365 * 50)
            random_date = datetime(1970, 1, 1) + timedelta(days=random_days)
            user['birthday'] = random_date.strftime('%m%d%Y')
            user['address']['state'] = self.get_random_word()
            user['create'] = 'new'
            
        return users
    
    def get_random_word(self):
        response = requests.get("https://random-word-api.vercel.app/api?words=1", verify=False)
        return response.json()[0].capitalize()

###################################    TEST CASE NO. 1     ################################### 

# DONE 1. Create identity for all reacord retrieved from "https://jsonplaceholder.typicode.com/users"
# 2. a. Verify that created records are displayed: Log To Console: All User Created Are Displayed 
#    b. Loop through all records and Log To Console: "Test Created User: <name>" if it's a newly created user, else "Existing User: <name>"
# 3. In the same loop, display respective column values. "Last seen", "Orders", "Total Spent"

###################################    TEST CASE NO. 2     ################################### 

# 1. Determine which users has 0 order. Fail execution if there are 1 or more users with 0 order. Error Message should be "Userts with 0 orders found: [<list_of_users_with_zero_orders>]"

# NOTE: MAXIMIZE KEYWORDS, Create/Use Suite Variabless if needed.