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
	                       		<input type="text" name="q" id="search_box" autofocus autocomplete="new-password" placeholder="What are you looking for?" title="Search here.." required oninvalid="this.setCustomValidity('Please enter search string')"/>
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
		int score_weight = get_value("score_weight",vars);
		int view_weight = get_value("view_weight",vars);
		int time_weight = get_value("time_weight",vars);
		int review_weight = get_value("review_weight",vars);
		int limit;
		ResultSet r;
		String search_q;
	%>
        <div class="container" id="trending">
            <div class="row">
                <div class="col-md-12">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading text-center"><u>Trending articles</u></h2>
                    <ul class="timeline">
                    <%
                    	limit = 5;
	                    int max_chars = 120;				
	                    r = stmt.executeQuery("SELECT SUM(view_count) AS total_views, SUM(time_count) AS total_time FROM articles");
	            		r.next();
	            		int total_views = r.getInt("total_views");
	            		int total_time= r.getInt("total_time");
	            		
                    	search_q = "SELECT * FROM articles ORDER BY (score * "+score_weight+")+((view_count*100/"+total_views+")*"+view_weight+")+((time_count*100/"+total_time+")*"+time_weight+")+(review_score*"+review_weight+") DESC LIMIT "+limit;
                    	r = stmt.executeQuery(search_q);
                    	String ta,time_when,abstr,cls;
                    	int id;
                    	int abstr_size = 300;
                    	String[] classes = {"blue","default"};
                    	int lp_cnt = 0;
                    	while(r.next())
                    	{
                    		id = r.getInt("id");
                    		ta = r.getString("title");
                    		if(ta.length() > max_chars + 3)
                    			ta = ta.substring(0,max_chars+1) + "...";
                    		abstr = get_simple_abstract(r.getString("name"),abstr_size);
                    		time_when = r.getString("time_when");
                    		cls = classes[lp_cnt%(classes.length)];
                    		lp_cnt++;
                    %>
                    <li>
	                  <i class="fa fa-thumb-tack bg-<%=cls%>"></i>
	                  <div class="timeline-item">
	                    <span class="time"><i class="fa fa-clock-o"></i> <%= get_time_diff(time_when)%></span>
	                    <h3 class="timeline-header"><a href="view_article.jsp?i=<%=id%>" target="_blank"><span class="text-<%=cls%>"><%=ta%></span></a></h3>
	                    <div class="timeline-body">
	                      <%=abstr %>
	                    </div>
	                  </div>
	                </li>
                    <%
                    	}
                    %>
                    </ul>
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
                    <h2 class="section-heading"><u>Popular searches</u></h2>
                    <ul class="timeline">
                    <%
                    	limit = 5;
                    	search_q = "SELECT id,search_string,SUM(click_cnt) AS cnt FROM `search` GROUP BY search_string ORDER BY cnt DESC LIMIT "+limit;
                    	r = stmt.executeQuery(search_q);
                    	String ss;
                    	lp_cnt = 0;
                    	String[] classes_2 = {"navy","default"};
                    	while(r.next())
                    	{
                    		ss = r.getString("search_string");
                    		cls = classes_2[lp_cnt%(classes_2.length)];
                    		lp_cnt++;
                    %>
                    <li>
	                  <i class="fa fa-search bg-<%=cls%>"></i>
	                  <div class="timeline-item">
	                    <h3 class="timeline-header">
	                    <a href="search.jsp?q=<%=ss%>" target="_blank">
	                    	<span class="text-<%=cls%>"><%=ss%></span>
	                    </a>
	                    </h3>
	                    
	                  </div>
	                </li>
                    <%
                    	}
                    %>
                    </ul>
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