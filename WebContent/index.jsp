<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="header.jsp" %>
	<link href="css/index.css" rel="stylesheet" type="text/css"/>
	<script src="js/index.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/search_box.js"></script>
	<a name="about"></a>
    <div class="intro-header">
        <div class="container">

            <div class="row">
                <div class="col-lg-12">
                    <div class="intro-message">
                        <h1>Classifier</h1><br/>
                        <form action="search.jsp">
	                       	<div id="search_div">
	                       		<input type="text" name="q" id="search_box" autocomplete="new-password" placeholder="What are you looking for?"/>
	                       		<div id="search_list"></div>
	                       	</div>
							<button id="search_button" class="btn">
								<i class="fa fa-search fa-fw"></i>
							</button>
						</form>
                    </div>
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.intro-header -->

    <!-- Page Content -->

	<a  name="trending"></a>
    <div class="content-section-a">
	<%
		int score_weight = 30;
		int view_weight = 30;
		int time_weight = 30;
		int review_weight = 30;
		int limit;
		ResultSet r;
		String search_q;
	%>
        <div class="container">
            <div class="row">
                <div class="col-lg-5 col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading"><u>Most viewed articles</u></h2>
                    <%
                    	limit = 5;
	                    int max_chars = 70;				
	                    r = stmt.executeQuery("SELECT SUM(view_count) AS total_views, SUM(time_count) AS total_time FROM articles");
	            		r.next();
	            		int total_views = r.getInt("total_views");
	            		int total_time= r.getInt("total_time");
	            		
                    	search_q = "SELECT * FROM articles ORDER BY (score * "+score_weight+")+((view_count*100/"+total_views+")*"+view_weight+")+((time_count*100/"+total_time+")*"+time_weight+")+(review_score*"+review_weight+") DESC LIMIT "+limit;
                    	r = stmt.executeQuery(search_q);
                    	String ta;
                    	int id;
                    	while(r.next())
                    	{
                    		id = r.getInt("id");
                    		ta = r.getString("title");
                    		if(ta.length() > max_chars + 3)
                    			ta = ta.substring(0,max_chars+1) + "...";
                    %>
                    	<p class="lead"><a target="_blank" href="view_article.jsp?i=<%=id%>"><b>
                    		<span class="trending_article_text">
                    			<span class="glyphicon glyphicon-pushpin"></span> <%=ta%>
                    		</span>
                    	</b></a></p>	
                    <%
                    	}
                    %>
                </div>
                <div class="col-lg-5 col-lg-offset-2 col-sm-6">
                	<br/><br/><br/>
                    <img class="img-responsive" src="img/trending.png" alt="">
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.content-section-a -->

    <div class="content-section-b">

        <div class="container">

            <div class="row">
                <div class="col-lg-5 col-lg-offset-1 col-sm-push-6  col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading"><u>What people search for most?</u></h2>
                    <%
                    	limit = 5;
                    	search_q = "SELECT id,search_string,SUM(click_cnt) AS cnt FROM `search` GROUP BY search_string ORDER BY cnt DESC LIMIT "+limit;
                    	r = stmt.executeQuery(search_q);
                    	String ss;
                    	while(r.next())
                    	{
                    		ss = r.getString("search_string");
                    %>
                    	<p class="lead"><a target="_blank" href="search.jsp?q=<%=ss%>"><b>
                    		<span class="trending_search_text">
                    			<span class="glyphicon glyphicon-search"></span> <%=ss%>
                    		</span>
                    	</b></a></p>	
                    <%
                    	}
                    %>
                </div>
                <div class="col-lg-5 col-sm-pull-6  col-sm-6">
                	<br/><br/><br/>
                    <img class="img-responsive" src="img/search.png" alt="">
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.content-section-b -->

    <div class="content-section-a">

        <div class="container">

            <div class="row">
                <div class="col-lg-5 col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading">Google Web Fonts and<br>Font Awesome Icons</h2>
                    <p class="lead">This template features the 'Lato' font, part of the <a target="_blank" href="http://www.google.com/fonts">Google Web Font library</a>, as well as <a target="_blank" href="http://fontawesome.io">icons from Font Awesome</a>.</p>
                </div>
                <div class="col-lg-5 col-lg-offset-2 col-sm-6">
                    <img class="img-responsive" src="img/phones.png" alt="">
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.content-section-a -->

	<a  name="contact"></a>
    <div class="banner">

        <div class="container">

            <div class="row">
                <div class="col-lg-6">
                    <h2>Connect with us:</h2>
                </div>
                <div class="col-lg-6">
                    <ul class="list-inline banner-social-buttons">
                        <li>
                            <a href="https://twitter.com/SBootstrap" class="btn btn-default btn-lg"><i class="fa fa-twitter fa-fw"></i> <span class="network-name">Twitter</span></a>
                        </li>
                        <li>
                            <a href="https://github.com/IronSummitMedia/startbootstrap" class="btn btn-default btn-lg"><i class="fa fa-github fa-fw"></i> <span class="network-name">Github</span></a>
                        </li>
                        <li>
                            <a href="#" class="btn btn-default btn-lg"><i class="fa fa-linkedin fa-fw"></i> <span class="network-name">Linkedin</span></a>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
<%@include file="footer.jsp" %>