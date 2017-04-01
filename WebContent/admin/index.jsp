<!DOCTYPE html>

<html >

<head>
<meta charset="UTF-8">
  
<title>Admin Panel</title>
<base href="${pageContext.request.contextPath}/"></base>
<link rel='stylesheet prefetch' href='http://fonts.googleapis.com/css?family=Open+Sans:600'>

 
<link rel="stylesheet" href="admin/resources/css/style1.css">

 

</head>


<body>
  
<div class="login-wrap">
	
<div class="login-html">
		
<input id="tab-1" type="radio" name="tab" class="sign-in" checked>
<label for="tab-1" class="tab">Sign In</label>
		
<input id="tab-2" type="radio" name="tab" class="sign-up">
<label for="tab-2" class="tab">Sign Up</label>
		
<div class="login-form">
			
<div class="sign-in-htm">
<form method="post" action="admin/check_login.jsp">	
<div class="group">
					
<label for="user" class="label">Username</label>
					
<input name="username" type="text" class="input">
				
</div>
				
<div class="group">
					
<label for="pass" class="label">Password</label>
					
<input name="password" type="password" class="input" data-type="password">
				
</div>
				
<div class="group">
					
<input id="check" type="checkbox" class="check" checked>
					
<label for="check"><span class="icon"></span> Keep me Signed in</label>
				
</div>
				
<div class="group">
					
<input type="submit" class="button" value="Sign In">
</form>
</div>
				
<div class="hr">
</div>
				
<div class="foot-lnk">
					
<a href="#forgot">Forgot Password?</a>
				
</div>
			
</div>
			
<div class="sign-up-htm">
<form method="post" action="user/register">
<div class="group">
					
<label for="user" class="label">Username</label>
					
<input name="username" type="text" class="input">
				
</div>
				
<div class="group">
					
<label for="pass" class="label">Password</label>
					
<input name="password" type="password" class="input" data-type="password">
				
</div>
				
<div class="group">
					
<label for="pass" class="label">Repeat Password</label>
					
<input id="pass" type="password" class="input" data-type="password">
				
</div>
				
<div class="group">
					
<label for="email" class="label">Email Address</label>
					
<input name="email" type="text" class="input">
				
</div>
				
<div class="group">
					
<input type="submit" class="button" value="Sign Up">
				</form>
</div>
				
<div class="hr"></div>
				
<div class="foot-lnk">
					
<label for="tab-1">Already Member?</a>
				
</div>
			
</div>
		
</div>
	
</div>
</div>
  
  

</body>

</html>