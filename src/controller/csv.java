package controller;
import com.jaunt.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.net.URLEncoder;
import java.sql.*;
import java.util.*;
import java.util.regex.Pattern;
public class csv {
	public static void main(String args[]) throws Exception
	{
		boolean debug = true;
		boolean oxf = true;
		int category_id = 10;
		int pages = 1;
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection ("jdbc:mysql://localhost/test", "root", "");
		Statement stmt = conn.createStatement();
		UserAgent userAgent = new UserAgent();         //create new userAgent (headless browser)
		
		ArrayList<String> links = new ArrayList<String>();
		
		ResultSet r = stmt.executeQuery("SELECT * FROM word_list");;
		HashMap<String,String> hm=new HashMap<String,String>();
		
		try (BufferedReader br = new BufferedReader(new FileReader(System.getProperty("user.dir")+"/remove_words.txt"))) {
		    String line;
		    while ((line = br.readLine()) != null) {
		    	hm.put(line,"Yes");
		    }
		}
		
		String wrd;
		int cat_id,cnt,word_id;
		while(r.next())
		{
			wrd = r.getString("word").toLowerCase();
			word_id = r.getInt("id");
			cat_id = r.getInt("category_id");
			cnt = 0;
			hm.put(wrd,"Yes");
		}
		int count = 0;
		try (BufferedReader br = new BufferedReader(new FileReader(System.getProperty("user.dir")+"/data.csv"))) {
		    String line;
		    while ((line = br.readLine()) != null && count < 100) {
		    	System.out.println(line.split("	")[2]);
		    	System.out.println(line);
		    	count++;
		    }
		}
		
		System.out.println("Done");
		stmt.close(); 
		conn.close();
		//DELETE FROM word_list WHERE word REGEXP '[^A-Za-z0-9]+'
	}
	public static boolean is_clean(String s,HashMap<String,String> hm)
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
	public static String refine(String s)
	{
		s = s.replaceAll("\\\\", "\\\\\\\\");
        s = s.replaceAll("\\n", "\\\\n");
        s = s.replaceAll("\\r", "\\\\r");
        s = s.replaceAll("\\00", "\\\\0");
        s = s.replaceAll("'", "\\\\'");
		s = s.toLowerCase();
		return s;
	}
}
