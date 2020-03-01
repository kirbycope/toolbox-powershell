# Close All Browser and WebDriver Processes

# Chrome - Browser
kill -processname chrome -ErrorAction SilentlyContinue 
# Chrome - WebDriver
kill -processname chromedriver -ErrorAction SilentlyContinue

# Firefox - Browser
kill -processname firefox -ErrorAction SilentlyContinue
# Firefox - WebDriver
kill -processname geckodriver -ErrorAction SilentlyContinue

# Internet Explorer - Browser
kill -processname iexplore -ErrorAction SilentlyContinue
# Internet Explorer - WebDriver
kill -processname IEDriverServer -ErrorAction SilentlyContinue

# Edge - Browser Pt.1
kill -processname MicrosoftEdge -ErrorAction SilentlyContinue
# Edge - Browser Pt.2
kill -processname MicrosoftEdgeCP -ErrorAction SilentlyContinue
# Edge - WebDriver
kill -processname MicrosoftWebDriver -ErrorAction SilentlyContinue

# Clear Chrome's Temp files
$path=$env:LOCALAPPDATA + "\Temp\scoped_dir*"
Remove-Item -Recurse -Force $path -ErrorAction SilentlyContinue