package controller;
import com.jaunt.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.net.URLEncoder;
import java.sql.*;
import java.util.*;
import java.util.regex.Pattern;
public class parse {
	public static void main(String args[]) throws Exception
	{
		boolean debug = true;
		boolean oxf = false;
		boolean onelook = false;
		int category_id = 1;
		int pages = 5;
		
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
		String l;
		if(oxf)
		{
			for(int i = 1; i <= pages; i++)
			{
				l = "http://www.oxfordreference.com/view/10.1093/acref/9780199679393.001.0001/acref-9780199679393?btog=chap&hide=true&page="+i+"&pageSize=100&skipEditions=true&sort=titlesort&source=%2F10.1093%2Facref%2F9780199679393.001.0001%2Facref-9780199679393";
				links.add(l);
			}
			List<String> ws = new ArrayList<String>();
			for(String link : links)
			{
				userAgent.visit(link);
				Elements words = userAgent.doc.findEvery("<h2 class=itemTitle>").findEvery("<a>");
				String s;
				
				for(Element word : words )
				{
					s = refine(word.getText());
					if(is_clean(s,hm))
					{
						System.out.println(s);
				        if(!debug)
				        {
				        	stmt.execute("INSERT into word_list(category_id,word,count,articles) VALUES ('"+category_id+"','"+s+"','0','')");
				        }
					}
				}
			}
		}
		else if(onelook)
		{
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=1");
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=101");
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=201");
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=301");
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=401");
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=501");
			links.add("http://www.onelook.com/?w=*:crime&ws1=1&first=601");
			List<String> ws = new ArrayList<String>();
			for(String link : links)
			{
				userAgent.visit(link);
				Elements words = userAgent.doc.findFirst("<table>").nextSiblingElement().findFirst("<table>").nextSiblingElement().nextSiblingElement().findEvery("<td>").findEvery("<a>");
				String s;
				
				for(Element word : words )
				{
					s = refine(word.getText());
					if(is_clean(s,hm))
					{
						ws.add(s);
					}
				}
			}
			Collections.sort(ws);
			for(String p : ws)
			{
				System.out.println(p);
				if(!debug)
		        {
					stmt.execute("INSERT into word_list(category_id,word,count,articles) VALUES ('"+category_id+"','"+p+"','0','')");
		        }
			}
			System.out.println(ws.size());
		}
		else
		{
			category_id = 1;
			links.add("http://www.enchantedlearning.com/wordlist/sports.shtml");
			List<String> ws = new ArrayList<String>();
			for(String link : links)
			{
				userAgent.visit(link);
				System.out.println(userAgent.doc.findFirst("<table>").nextSiblingElement().nextSiblingElement().nextSiblingElement().getText());
				Elements words = userAgent.doc.findFirst("<TABLE CELLPADDING='2'>").findEvery("<tr>");
				String s;
				for(Element tr : words )
				{
					Elements td = tr.findEvery("<td>");
					for(Element word : td )
					{
						System.out.println(word.getText());
						s = refine(word.getText());
						if(!is_clean(s,hm))
						{
							ws.add(s);
						}
					}
				}
			}
			Collections.sort(ws);
			for(String p : ws)
			{
				System.out.println(p);
				if(!debug)
		        {
					stmt.execute("INSERT into word_list(category_id,word,count,articles) VALUES ('"+category_id+"','"+p+"','0','')");
		        }
			}
			System.out.println(ws.size());
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
