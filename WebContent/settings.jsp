<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.*,java.io.*" %>
<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection c = DriverManager.getConnection("jdbc:mysql://localhost/test","root","");
	Statement stmt = c.createStatement();
%>
<%!
	public static int get_value(String name, HashMap<String,String> vars)
	{
		return Integer.parseInt(vars.get(name).split(":")[1]);
	}
	public static String get_simple_abstract(String name,int len)
	{
		try{
			String path = System.getProperty("user.dir")+"/";
			File file = new File(path+name);
			FileInputStream fis = new FileInputStream(file);
			byte[] data = new byte[(int) file.length()];
			fis.read(data);
			fis.close();
			return new String(data, "UTF-8").replaceAll("[^\\x00-\\x7F]", "").substring(0,len) + "...";
		}catch(Exception e)
		{
			
		}
		return name;
	}
	public static String get_time_diff(String time)
	{
		if(time.length() > 19)
			time = time.substring(0,19);
		
		String future_date = "Future date";
		
		String[] var_date = time.split(" ")[0].split("-");
		String[] var_time = time.split(" ")[1].split(":");
		
		Timestamp t = new Timestamp(Integer.parseInt(var_date[0]) - 1900,Integer.parseInt(var_date[1])-1,Integer.parseInt(var_date[2]),Integer.parseInt(var_time[0]),Integer.parseInt(var_time[1]),Integer.parseInt(var_time[2]),0);
		
		long diff = System.currentTimeMillis() - t.getTime();
		diff /= 1000;
		if(diff <= 0)
			return future_date;
		else
		{
			if(diff < 20)
				return "Just now";
			else if(diff < 60)
				return diff + " seconds ago";
			else if(diff < 120)
				return "1 minute ago";
			else if(diff < 3600)
				return (diff/60) + " minutes ago";
			else if(diff < 7200)
				return "1 hour ago";
			else if(diff < 86400)
				return (diff/3600) + " hours ago";
			else if(diff < 172800)
				return "1 day ago";
			else if(diff < 604800)
				return (diff/86400) + " days ago";
			else if(diff < 1209600)
				return "1 week ago";
			else if(diff < 2592000)
				return (diff/604800) + " weeks ago";
			else if(diff < 5184000)
				return "1 month ago";
			else if(diff < 31104000)
				return (diff/2592000) + " months ago";
			else if(diff < 62208000)
				return "1 year ago";
			else
				return (diff/31104000) + " years ago";
		}
	}
%>
<%
	HashMap<String,String> vars=new HashMap<String,String>();
	
	try (BufferedReader br = new BufferedReader(new FileReader(System.getProperty("user.dir")+"/variables.txt"))) {
	    String line;
	    String[] arr = new String[2];
	    while ((line = br.readLine()) != null) {
	    	arr = line.split(",");
	    	vars.put(arr[0],arr[1]);
	    }
	}
%>