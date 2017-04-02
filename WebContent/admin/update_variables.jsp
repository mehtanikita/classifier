<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="authenticate.jsp" %>
<%@include file="settings.jsp" %>
<%
	HashMap<String,String> var=new HashMap<String,String>();
	String f_name = System.getProperty("user.dir")+"/variables.txt";
	
	try (BufferedReader br = new BufferedReader(new FileReader(f_name))) {
	    String line;
	    String[] arr = new String[2];
	    while ((line = br.readLine()) != null) {
	    	arr = line.split(",");
	    	var.put(arr[0],arr[1]);
	    }
	}
	String name = request.getParameter("name");
	String value = request.getParameter("value");
	
	String temp = var.get(name);
	String[] arr = temp.split(":");
	arr[1] = value;
	temp = arr[0]+":"+arr[1];
	var.put(name,temp);
	
	PrintStream fw = new PrintStream(new File(f_name));
	 
	Iterator it = var.entrySet().iterator();
    while (it.hasNext()) {
        Map.Entry pair = (Map.Entry)it.next();
        fw.println(pair.getKey() + "," + pair.getValue());
        it.remove();
    }
 
	fw.close();
%>