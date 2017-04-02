<!DOCTYPE html>
<html >
<head>
  <meta charset="UTF-8">
  <title>Material Design Login Form</title>
  <base href="${pageContext.request.contextPath}/"></base>
  <link rel="stylesheet" href="admin/resources/css/index.css">
</head>

<body>
  <hgroup>
  <h1>Admin Panel</h1>
</hgroup>
	<form action="admin/check_login.jsp" method="POST">
		 <div class="group">
		   <input type="text" name="username" required><span class="highlight"></span><span class="bar"></span>
		   <label>Username</label>
		 </div>
		 <div class="group">
		   <input type="password" name="password" required><span class="highlight"></span><span class="bar"></span>
		   <label>Password</label>
		 </div>
		 <button type="submit" class="button buttonBlue">Login
		   <div class="ripples buttonRipples"><span class="ripplesCircle"></span></div>
		 </button>
	</form>
  	<script src='admin/resources/js/jquery.js'></script>

    <script src="admin/resources/js/index.js"></script>

</body>
</html>
