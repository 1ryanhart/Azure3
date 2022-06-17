# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 

#This will include logging in, 
# adding 6 different items to a cart, 
# and removing those items from the cart. 
# 
# The results of the test will show which user logged in, which items were added to the cart, and which items were removed from the cart, and will consist of a screenshot of the execution of the test suite by the CI/CD pipeline.

options = ChromeOptions()
options.add_argument("--headless") 
driver = webdriver.Chrome(options=options)
print ('Browser started successfully. Navigating to the demo page to login.')
driver.get('https://www.saucedemo.com/')

# Start the browser and login with standard_user
def login (user, password):
    print ('Starting the browser...')
    # --uncomment when running in Azure DevOps.


    driver.find_element_by_css_selector("input[id='user-name']").send_keys(user)
    driver.find_element_by_css_selector("input[id='password']").send_keys(password)
    driver.find_element_by_css_selector("input[id='login-button']").click()
    # driver.find_element(By.ID, "user-name").send_keys(user)
    # driver.find_element(By.ID, "password").send_keys(password)
    # driver.find_element(By.ID, "login-button").click()
    print('Successfully logged in as ' + user )

def add_to_cart():
    print('Adding all 6 items to cart')
    items = driver.find_elements_by_css_selector("button.btn_primary.btn_inventory")

    for item in items:
        print('Adding item to the cart')
        item.click()
    cart_label = driver.find_element_by_css_selector('.shopping_cart_badge').text
    assert cart_label == '6'


def remove_from_cart():
    driver.find_element_by_css_selector("a[class='shopping_cart_link']").click()
    print('Removing all 6 items to cart')
    items = driver.find_elements_by_css_selector("button.cart_button")

    for item in items:
        print('Removing item to the cart')
        item.click()
    

login('standard_user', 'secret_sauce')
add_to_cart()
remove_from_cart()

