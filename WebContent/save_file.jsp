<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*, java.lang.*, java.text.DecimalFormat, java.math.*, controller.WordDetails" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@include file="header.jsp" %>
<% 
	int count_weight = 50;		//Weight of number of words in deciding category
	int frequency_weight = 50;	//Weight of frequency of words in deciding category
	
	ResultSet r = stmt.executeQuery("SELECT MAX(id) AS m_id FROM articles");
	
	int m_id = 0;
	while(r.next())
		m_id = r.getInt("m_id");
	int id = m_id + 1;
	
	String txt = "";
	String type = request.getParameter("type");
	String title = "";
	String path = System.getProperty("user.dir");
	String name = "Article_"+id+".txt";
	String fpath = path + "/" + name;
	String tags = "";
	String s_tags = "";
	int total_words = 0, total_freq = 0;
	//Get text
	File file ;
	int maxFileSize = 5000 * 1024;
	int maxMemSize = 5000 * 1024;

	String contentType = request.getContentType();
	if ((contentType.indexOf("multipart/form-data") >= 0)) {
	
	   DiskFileItemFactory factory = new DiskFileItemFactory();
	   factory.setSizeThreshold(maxMemSize);
	   factory.setRepository(new File(fpath));
	
	   ServletFileUpload upload = new ServletFileUpload(factory);
	   upload.setSizeMax( maxFileSize );
	   try{ 
	      List fileItems = upload.parseRequest(request);
	      Iterator i = fileItems.iterator();
	
	      while ( i.hasNext () ) 
	      {
	         FileItem fi = (FileItem)i.next();
	         title = fi.getName();
	         if ( !fi.isFormField () )	
	         {
	        	 BufferedInputStream buff=new BufferedInputStream(fi.getInputStream());
                 byte []bytes=new byte[buff.available()];
                 buff.read(bytes,0,bytes.length);
                 txt = new String(bytes);
	         }
	      }
	   }catch(Exception ex) {
	      System.out.println(ex);
	   }
	}
	else if(type.equals("text"))
	{
		title = (String)request.getParameter("title");
		txt = (String)request.getParameter("file_text");
	}
	else{
	   response.sendRedirect("upload.jsp");
	}
	if (title.indexOf(".") > 0)
		title = title.substring(0, title.lastIndexOf("."));
		
	//Save file
	try {
		File file_2 = new File(fpath);
		FileWriter fileWriter = new FileWriter(file_2);
		fileWriter.write(txt);
		fileWriter.flush();
		fileWriter.close(); 
	}
	catch (IOException e)
	{ e.printStackTrace(); } 
	
	//Algo
	int max_id = 0;
	try {
		
		r = stmt.executeQuery("SELECT * FROM word_list");
		
		HashMap<String,WordDetails> hm=new HashMap<String,WordDetails>();
		HashMap<String,Integer> hm1=new HashMap<String,Integer>();
		String wrd;
		int cat_id,cnt;
		while(r.next())
		{
			wrd = r.getString("word");
			String wrd1=wrd.toLowerCase();
			cat_id = r.getInt("category_id");
			cnt = r.getInt("count");
			hm.put(wrd1,new WordDetails(new Integer(cat_id),new Integer(cnt)));
		}
		WordDetails wd;
		
		HashMap<Integer,Integer> word_cnt=new HashMap<Integer,Integer>();
		HashMap<Integer,Integer> freq_cnt=new HashMap<Integer,Integer>();
		HashMap<Integer,Integer> score = new HashMap<Integer,Integer>();
		HashMap<Integer,String> category = new HashMap<Integer,String>();
		
		ResultSet r2 = stmt.executeQuery("SELECT * FROM category");
		int tmp_id,w_cnt,f_cnt;
		while(r2.next())
		{
			tmp_id  = r2.getInt("id");
			word_cnt.put(tmp_id,0);
			freq_cnt.put(tmp_id,0);
			score.put(tmp_id, 0);
			category.put(tmp_id, r2.getString("name"));
		}
		
		String s = txt.toLowerCase();
		s = s.replaceAll("[^a-z0-9 ]", "");
		
		while(s.indexOf("  ")>-1)
		{
			s=s.replace("  "," ");
		}
		if(s.equals(""))
		{}
		else
		{
			WordDetails w1;
			String[] str = s.split("\\s");	
			for(String w:str)
			{  	
				w1 = hm.get(w);
				if(w1 != null)
				{
					w1.cnt += 1;
					hm.put(w, new WordDetails(new Integer(w1.cat_id),new Integer(w1.cnt)));
				}
			}
			for(Map.Entry m:hm.entrySet())
			{
				wd = (WordDetails)m.getValue();
				System.out.println(m.getKey()+" : Category_ID = "+wd.cat_id+" : Word_Count = "+wd.cnt);
				if(wd.cnt > 0)
				{
					tmp_id = wd.cat_id;
					w_cnt = word_cnt.get(tmp_id);
					f_cnt = freq_cnt.get(tmp_id);
					w_cnt += 1;
					f_cnt += wd.cnt;
					word_cnt.put(tmp_id,w_cnt);
					freq_cnt.put(tmp_id,f_cnt);

					hm1.put((String) m.getKey(), wd.cnt);
	
					total_words++;
					total_freq += wd.cnt;
				}
			}
		}
		
		int max_score = 0;
		int tmp_score, total_score = 0;
		float max_percent = 0;
		for(Map.Entry m:score.entrySet())
		{
			tmp_id = (Integer)m.getKey();
			w_cnt = word_cnt.get(tmp_id);
			f_cnt = freq_cnt.get(tmp_id);
			tmp_score = (count_weight * (w_cnt*100/total_words)) + (frequency_weight * (f_cnt*100/total_freq));
			score.put(tmp_id, tmp_score);
			total_score += tmp_score;
			if(tmp_score > max_score)
			{
				max_score = tmp_score;
				max_id = tmp_id;
			}
		}
		//out.println("The article belongs to category: " + category.get(max_id)+"<br/>");
		max_percent = (float)max_score*100/total_score;
		DecimalFormat df = new DecimalFormat("#.##");
		df.setRoundingMode(RoundingMode.CEILING);
		Double percent;
%>
<div id="main_div">
	<link href="css/article_report.css" rel="stylesheet" type="text/css"/>
	<div id="analysis_div" class="col-md-offset-3 col-md-6">
		<div id="analysis_head">
			Article Analysis
		</div>
		<div id="analysis_body">
			<h3 class="text-center">Classified as "<%= category.get(max_id) %>" article.</h3>
			<%
				String cls = "";
				String cats = "";
				String scores ="";
				int cat_cnt = 0;
				String others = "";
				for(Map.Entry m:score.entrySet())
				{
					tmp_id = (Integer)m.getKey();
					tmp_score = (Integer)m.getValue();
					if(total_score != 0)
					{
						percent = ((double)tmp_score/(double)total_score)*100;
						if(tmp_score > 0)
						{
							if(!df.format(percent).equals(df.format(max_percent)))
								others += tmp_id+":"+df.format(percent)+",";
							cats += "'" + category.get(tmp_id) + "',";
							scores += df.format(percent) + ",";
							cat_cnt++;
							if(percent > 80)
								cls = "success";
							else if(percent > 60)
								cls = "primary";
							else if(percent > 40)
								cls = "info";
							else if(percent > 20)
								cls = "warning";
							else
								cls = "danger";
					
				%>
					<div class="col-md-12">
						<div class="col-md-4">
							<h3><%= category.get(tmp_id) %>: </h3> 
						</div>
						<div class="col-md-6">
							<div class="progress progress_tip tip_<%= cls%> pointer" data-toggle="tooltip" data-placement="bottom" title="<%= df.format(percent) + '%'%>" style="width: 90%; margin-top: 25px">
								<div class="progress-bar progress-bar-<%= cls%> text-center" role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" wid="<%= df.format(percent)%>">
								</div>
							</div>
						</div>
					</div>
				<%
					
						}
					}
					else
						percent = 0.00;
					//out.println(category.get(tmp_id) + " : " + df.format(percent) + " %"+"<br/>");
				}
				others = others.substring(0,others.length()-1);
			%>
			<%
			if(cats.length() > 0)
			{
				cats = cats.substring(0, cats.length()-1);
				cats.replaceAll("\'","\\\\'");
				scores = scores.substring(0, scores.length()-1);
			}
			%>
		</div>
		<div id="analysis_body">
			<script type="text/javascript" src="js/chart.js"></script>
			<canvas id="myChart" width="500" height="200"></canvas>
			<script>
				var colors = ['rgba(54, 162, 235, 0.4)', 'rgba(255, 206, 86, 0.4)', 'rgba(255, 99, 132, 0.4)',
				                'rgba(75, 192, 192, 0.4)', 'rgba(153, 102, 255, 0.4)', 'rgba(255, 159, 64, 0.4)']
				var ctx = document.getElementById("myChart");
				var config = {
					    type: 'pie',
					    data: {
					        labels: [<%= cats%>],
					        datasets: [{
					            label: 'Percentage Score',
					            data: [<%= scores%>],
					            backgroundColor: [
					              <%  
					              for(int p=0; p<cat_cnt; p++)
					              {
					            	out.println("colors["+(p%6)+"],");
					              }
					              %> 
					            ],
					            borderColor: [
								<%  
					              for(int p=0; p<cat_cnt; p++)
					              {
					            	out.println("colors["+(p%6)+"],");
					              }
					              %> 
					            ],
					            borderWidth: 1,
					            /*barThickness: 30*/
					        }]
					    },
					    options: {
					        /* scales: {
					        	xAxes:[{
					        		barThickness: 30
					        	}],
					            yAxes: [{
					                ticks: {
					                    beginAtZero:true
					                }
					            }],
					            
					        } */
					    }
					};
				var temp = jQuery.extend(true, {}, config);
				var myChart = new Chart(ctx, temp);
			</script>
		</div>
		<script type="text/javascript">
			$(document).ready(function()
			{
				$(".progress-bar").each(function()
				{
					$(this).animate({width : $(this).attr('wid')+'%'},200);
				});
			});
		</script>
		<div id="analysis_body">
		<h3 class="text-center"><u>Popular Tags</u></h3>
		<div id="tags_div">
		<%
			Object[] a = hm1.entrySet().toArray();
			Arrays.sort(a, new Comparator()
			{
			    public int compare(Object o1, Object o2)
			    {
			        return ((Map.Entry<String, Integer>) o2).getValue().compareTo(((Map.Entry<String, Integer>) o1).getValue());
			    }
			});
			int count = 5,mcnt=0;
			String tag = "";
			String[] classes = {"success","primary","danger","info","warning"};
			for (Object e : a)
			{
				if(count>0)
				{
					tag = ((Map.Entry<String, Integer>) e).getKey();
					mcnt = ((Map.Entry<String, Integer>) e).getValue();
					tags += "'"+tag+"',";
					s_tags += tag+","; 
					stmt.executeUpdate("INSERT into tags VALUES ('','"+tag+"',"+id+",'"+mcnt+"')");
				%>
					<a href="explore_tags.jsp?t=<%=tag%>" target="_blank" title="Explore">
						<span class="label label-<%= classes[count%5]%>"><%=tag%> <span class="badge"><%=mcnt %></span></span>
					</a>
				<%
				}
					
				count--;
			}
			if(tags.length() > 0)
			{
				tags = tags.substring(0, tags.length()-1);
				tags.replaceAll("\'","\\\\'");
				s_tags = s_tags.substring(0, s_tags.length()-1);
			}
			//stmt.executeUpdate("INSERT into articles VALUES ("+id+",'"+title+"','"+name+"',"+max_id+",'"+df.format(max_percent)+"','0','0',\""+tags+"\",'"+s_tags+"','"+others+"')");
		}
		catch(Exception e)
		{ System.out.println(e); }
		%>
		</div>
		</div>
	</div>
</div>
<%@include file="footer.jsp" %>