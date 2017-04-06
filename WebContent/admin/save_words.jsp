<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="settings.jsp" %>
<%@page import="java.util.regex.Pattern" %>
<%!
	public boolean is_clean(String s,HashMap<String,String> hm)
	{
		String w1 = (String) hm.get(s);
		Pattern p = Pattern.compile("[^a-zA-Z0-9]");
		boolean hasSpecialChar = p.matcher(s).find();
		if(!hasSpecialChar)
		{
			if(w1 == null)
			{
				return true;
			}
		}
		return false;
	}
	public String refine(String s)
	{
		s = s.replaceAll("\\\\", "\\\\\\\\");
	    s = s.replaceAll("\\n", "\\\\n");
	    s = s.replaceAll("\\r", "\\\\r");
	    s = s.replaceAll("\\00", "\\\\0");
	    s = s.replaceAll("'", "\\\\'");
		s = s.toLowerCase().trim();
		return s;
	}
%>
<%
	int cat_id = Integer.parseInt(request.getParameter("category"));
	String[] words = request.getParameter("words").split(",");
	
	ResultSet r = stmt.executeQuery("SELECT * FROM word_list");;
	HashMap<String,String> hm=new HashMap<String,String>();
	
	try (BufferedReader br = new BufferedReader(new FileReader(System.getProperty("user.dir")+"/remove_words.txt"))) {
	    String line;
	    while ((line = br.readLine()) != null) {
	    	hm.put(line,"Yes");
	    }
	}
	
	String wrd;
	int cnt,word_id;
	while(r.next())
	{
		wrd = r.getString("word").toLowerCase();
		hm.put(wrd,"Yes");
	}
	String sql = "INSERT into word_list(category_id,word,count,articles) VALUES ";
	for(String w : words)
	{
		w = refine(w);
		if(is_clean(w,hm))
			sql += "('"+cat_id+"','"+w+"','0',''),";
	}
	sql = sql.substring(0,sql.length()-1);
	stmt.executeUpdate(sql);
	response.sendRedirect("add_words.jsp");
%>