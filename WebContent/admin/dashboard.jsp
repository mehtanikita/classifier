<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="header.jsp" %>
<%@include file="sidebar.jsp" %>
<link rel="stylesheet" href="admin/resources/css/morris.css"/>
<link rel="stylesheet" href="admin/resources/css/bootstrap-slider.css"/>
<script src="admin/resources/js/morris.js"></script>
<script src="admin/resources/js/raphael.js"></script>
<script src="admin/resources/js/bootstrap-slider.js"></script>
<% 
	int record_days = get_value("record_days",vars);;
	String query;
	ResultSet r;
	
	query = "SELECT COUNT(*) AS ar_cnt FROM articles WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+record_days+" DAY) ORDER BY time_when DESC";
	r = stmt.executeQuery(query);
	r.next();
	int ar_cnt = r.getInt("ar_cnt");
	
	query = "SELECT COUNT(*) AS srch_cnt FROM (SELECT * FROM `search` WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+record_days+" DAY) GROUP BY search_string ORDER BY time_when DESC) AS tmp_tab";
	r = stmt.executeQuery(query);
	r.next();
	int srch_cnt = r.getInt("srch_cnt");
	
	query = "SELECT COUNT(*) AS rv_cnt FROM reviews WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+record_days+" DAY) ORDER BY time_when DESC";
	r = stmt.executeQuery(query);
	r.next();
	int rv_cnt = r.getInt("rv_cnt");
	
	query = "SELECT SUM(time_count) AS tm_cnt FROM articles WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+record_days+" DAY)";
	r = stmt.executeQuery(query);
	r.next();
	int tm_cnt = r.getInt("tm_cnt");
	tm_cnt /= 3600;
%>
<div class="row">
   <div class="col-lg-3 col-xs-6">
     <!-- small box -->
     <div class="small-box bg-aqua">
       <div class="inner">
         <h3><%=ar_cnt %></h3>
         <p>New Articles</p>
       </div>
       <div class="icon">
         <i class="ion ion-clipboard"></i>
       </div>
       <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
     </div>
   </div><!-- ./col -->
   <div class="col-lg-3 col-xs-6">
     <!-- small box -->
     <div class="small-box bg-green">
       <div class="inner">
         <h3><%=srch_cnt %></h3>
         <p>Latest Searches</p>
       </div>
       <div class="icon">
         <i class="ion ion-ios-search-strong"></i>
       </div>
       <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
     </div>
   </div><!-- ./col -->
   <div class="col-lg-3 col-xs-6">
     <!-- small box -->
     <div class="small-box bg-yellow">
       <div class="inner">
         <h3><%=rv_cnt %></h3>
         <p>User Reviews</p>
       </div>
       <div class="icon">
         <i class="ion ion-ios-star-half"></i>
       </div>
       <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
     </div>
   </div><!-- ./col -->
   <div class="col-lg-3 col-xs-6">
     <!-- small box -->
     <div class="small-box bg-red">
       <div class="inner">
         <h3><%=tm_cnt %></h3>
         <p>Hours Views</p>
       </div>
       <div class="icon">
         <i class="ion ion-ios-timer-outline"></i>
       </div>
       <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
     </div>
   </div><!-- ./col -->
 </div><!-- /.row -->
 <div class="col-md-12 lr0pad">
 	<div class="box box-primary">
       <div class="box-header with-border">
         <h3 class="box-title">Search Graph</h3>
         <div class="box-tools pull-right">
           <button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
           <button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
         </div>
       </div>
       <div class="box-body chart-responsive">
         <div class="chart" id="line-chart" style="height: 300px;"></div>
       </div><!-- /.box-body -->
     </div><!-- /.box -->
 </div>
 <%
 	query = "SELECT DATE(time_when) s_date, COUNT(search_string) s_cnt FROM search WHERE time_when > DATE_SUB(CURDATE(), INTERVAL "+record_days+" DAY) GROUP BY DATE(time_when)";
	r = stmt.executeQuery(query);
 %>
 <script type="text/javascript">
 	 
 	 console.log()
	 var line = new Morris.Line({
	     element: 'line-chart',
	     resize: true,
	     data: [
	     <%
	     	while(r.next())
	     	{
	     		out.println("{ year: '"+r.getString("s_date")+"', value: "+r.getInt("s_cnt")+" },");
	     	}
	     %>
	     ],
	     xkey: 'year',
	     ykeys: ['value'],
	     xLabels: "day",
	     xLabelFormat: function(x){ return x.toString().substring(4,15); },
	     labels: ['Search Count'],
	     lineColors: ['#3c8dbc'],
	     hideHover: 'auto'
	   });

 </script>
 <%
 	String[] colors = {"red","blue","green","yellow","aqua","purple"};
 	int lp_cnt = 0;
%>
 <div class="col-md-12 lr0pad">
 	<div class="col-md-6 l0pad">
	   <div class="box box-danger">
         <div class="box-header with-border">
           <h3 class="box-title">Algorithm Weights</h3>
         </div><!-- /.box-header -->
         <div class="box-body">
           <div class="row margin">
           		<p style="margin-bottom: 10px"><%=get_name("tag_weight",vars) %></p>
                <input data-slider-id="red" var_name="tag_weight" data-slider-value="<%=get_value("tag_weight",vars)%>" type="text" class="slider form-control" data-slider-min="0" data-slider-max="100" data-slider-step="1" data-slider-handle="round" />
                
                <p style="margin-bottom: 10px"><%=get_name("score_weight",vars) %></p>
                <input data-slider-id="blue" var_name="score_weight" data-slider-value="<%=get_value("score_weight",vars)%>" type="text" class="slider form-control" data-slider-min="0" data-slider-max="100" data-slider-step="1" data-slider-handle="round" />
                
                <p style="margin-bottom: 10px"><%=get_name("view_weight",vars) %></p>
                <input data-slider-id="green" var_name="view_weight" data-slider-value="<%=get_value("view_weight",vars)%>" type="text" class="slider form-control" data-slider-min="0" data-slider-max="100" data-slider-step="1" data-slider-handle="round" />
                
                <p style="margin-bottom: 10px"><%=get_name("time_weight",vars) %></p>
                <input data-slider-id="yellow" var_name="time_weight" data-slider-value="<%=get_value("time_weight",vars)%>" type="text" class="slider form-control" data-slider-min="0" data-slider-max="100" data-slider-step="1" data-slider-handle="round" />
                
                <p style="margin-bottom: 10px"><%=get_name("review_weight",vars) %></p>
                <input data-slider-id="purple" var_name="review_weight" data-slider-value="<%=get_value("review_weight",vars)%>" type="text" class="slider form-control" data-slider-min="0" data-slider-max="100" data-slider-step="1" data-slider-handle="round" />
           </div>
         </div><!-- /.box-body -->
       </div><!-- /.box -->
 	</div>
 	<div class="col-md-6 r0pad">
 		<div class="box box-warning">
         <div class="box-header with-border">
           <h3 class="box-title">Miscellaneous</h3>
         </div><!-- /.box-header -->
         <div class="box-body">
           <div class="row margin">
           		<p style="margin-bottom: 10px"><%=get_name("record_days",vars) %></p>
                <input data-slider-id="red" var_name="record_days" data-slider-value="<%=get_value("record_days",vars)%>" type="text" class="slider form-control" data-slider-min="1" data-slider-max="180" data-slider-step="1" data-slider-handle="round" />
                
                <p style="margin-bottom: 10px"><%=get_name("articles_per_page",vars) %></p>
                <input data-slider-id="blue" var_name="articles_per_page" data-slider-value="<%=get_value("articles_per_page",vars)%>" type="text" class="slider form-control" data-slider-min="1" data-slider-max="25" data-slider-step="1" data-slider-handle="round" />
                
                <p style="margin-bottom: 10px"><%=get_name("abstract_size",vars) %></p>
                <input data-slider-id="green" var_name="abstract_size" data-slider-value="<%=get_value("abstract_size",vars)%>" type="text" class="slider form-control" data-slider-min="100" data-slider-max="1000" data-slider-step="20" data-slider-handle="round" />
                
           </div>
         </div><!-- /.box-body -->
       </div><!-- /.box -->
 	</div>
 </div>
 <script type="text/javascript">
 	$(document).ready(function () {
 	    $('.slider').slider();
 	    
 	    $('.slider').on('slideStop', function (e) {
 	       var value = $(this).val();
 	       var name = $(this).attr("var_name");
 	       if(name != "" && name != null && name != undefined) {
 	    	  $.ajax
 	    	  ({
 	    		 type: "POST",
 	    		 url: "admin/update_variables.jsp",
 	    		 data: { name: name, value: value },
 	    		 success: function(response)
 	    		 {
 	    			 
 	    		 },
 	    		 error: function(response)
 	    		 {
 	    			 alert('Error Occured!');
 	    		 }
 	    	  });
 	       }
 	    });
 	});
 </script>
<%@include file="footer.jsp" %>