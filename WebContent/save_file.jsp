<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.sql.*, java.util.*, java.lang.*, java.text.DecimalFormat, java.math.*, controller.WordDetails" %>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@include file="header.jsp" %>
<% 
	int count_weight = 50;		//Weight of number of words in deciding category
	int frequency_weight = 250;	//Weight of frequency of words in deciding category
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection c = DriverManager.getConnection("jdbc:mysql://localhost/test","root","");
	Statement stmt = c.createStatement();
	ResultSet r = stmt.executeQuery("SELECT MAX(id) AS m_id FROM articles");
	
	int m_id = 0;
	while(r.next())
		m_id = r.getInt("m_id");
	int id = m_id + 1;
	
	String txt = "";
	String type = request.getParameter("type");
	String path = System.getProperty("user.dir");
	String name = "Article_"+id+".txt";
	String fpath = path + "/" + name;
	String tags = "";
	
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
		txt = (String)request.getParameter("file_text");
	}
	else{
	   response.sendRedirect("upload.jsp");
	}
	
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
				//System.out.println(m.getKey()+" : Category_ID = "+wd.cat_id+" : Word_Count = "+wd.cnt);
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
				}
			}
		}
		
		int max_score = 0;
		int tmp_score, total_score = 0;
		for(Map.Entry m:score.entrySet())
		{
			tmp_id = (Integer)m.getKey();
			w_cnt = word_cnt.get(tmp_id);
			f_cnt = freq_cnt.get(tmp_id);
			tmp_score = (count_weight * w_cnt) + (frequency_weight * f_cnt);
			score.put(tmp_id, tmp_score);
			total_score += tmp_score;
			if(tmp_score > max_score)
			{
				max_score = tmp_score;
				max_id = tmp_id;
			}
		}
		//out.println("The article belongs to category: " + category.get(max_id)+"<br/>");
		
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
			<h3 class="text-center">Classified as <%= category.get(max_id) %> article.</h3>
			<%
				String cls = "";
				for(Map.Entry m:score.entrySet())
				{
					tmp_id = (Integer)m.getKey();
					tmp_score = (Integer)m.getValue();
					if(total_score != 0)
						percent = ((double)tmp_score/(double)total_score)*100;
					else
						percent = 0.00;
					//out.println(category.get(tmp_id) + " : " + df.format(percent) + " %"+"<br/>");
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
			%>
		</div>
	</div>
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
		for (Object e : a)
		{
			if(count>0)
			{
				tag = ((Map.Entry<String, Integer>) e).getKey();
				mcnt = ((Map.Entry<String, Integer>) e).getValue();
				tags += "'"+tag+"',";
				stmt.executeUpdate("INSERT into tags VALUES ('','"+tag+"',"+id+",'"+mcnt+"')");
			}
				
			count--;
		}
		if(tags.length() > 0)
		{
			tags = tags.substring(0, tags.length()-1);
			tags.replaceAll("\'","\\\\'");
		}
		stmt.executeUpdate("INSERT into articles VALUES ("+id+",'"+name+"',"+max_id+",\""+tags+"\")");	
	}
	catch(Exception e)
	{ System.out.println(e); }
%>
<%@include file="footer.jsp" %>