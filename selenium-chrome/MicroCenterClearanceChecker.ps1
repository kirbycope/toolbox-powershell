# Run just the following line of code if you cannot run the entire script
#Set-ExecutionPolicy RemoteSigned

#region Imports

# Get the file path of this (running) .ps1 file
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

# Import the SeleniumCore file
. "$dir\SeleniumCore.ps1"

#endregion Imports

#region Selenium elements

$pTopPagination = [OpenQA.Selenium.By]::CssSelector("#topPagination > p")
$aTopPaginationNext = [OpenQA.Selenium.By]::CssSelector("#bottomPagination > ul.pages.inline > li:last-child > a")

$liProductWrapper = [OpenQA.Selenium.By]::CssSelector("li.product_wrapper")
$aProductDescription = [OpenQA.Selenium.By]::CssSelector("div.normal > h2 > a")
$spanProductSku = [OpenQA.Selenium.By]::CssSelector("div.result_right > div > div.detail_wrapper > p")
$spanProductPrice = [OpenQA.Selenium.By]::CssSelector("div.result_right > div > div.price_wrapper > div.price > span")

#endregion Selenium elements

function Main()
{
    # Open a new Chrome browser window
    SetUp-WebDriver

    # Go to page
    Go-To-Url "http://www.microcenter.com/search/search_results.aspx?N=518+4294964290&storeid=181&Ntk=all&sortby=pricelow&myStore=true"

    # Loop over each page until told to break out
    while ($true)
    {
        # Wait for the top pagination to load
        Wait-For-Element $pTopPagination
        # Get all the products listed on this page
        $productsOnCurrentPage = Find-Elements $liProductWrapper
        # Parse over each product
        foreach ($product in $productsOnCurrentPage)
        {
            $sku = $product.FindElement($spanProductSku).Text
            $sku = $sku.Substring($sku.indexOf(" ") + 1)
            $desc = $product.FindElement($aProductDescription).Text
            $price = $product.FindElement($spanProductPrice).Text
        }
        # Check for the link for the next page
        if (Displayed $aTopPaginationNext)
        {
            # Click the 'Next' page link
            Click $aTopPaginationNext
        }
        else
        {
            break;
        }
    }

    # Close Chrome
    TearDown-WebDriver
}

# Call the Main() method
Main
