package controller;
import java.util.*;
import java.io.*;
import java.lang.*;
import java.sql.*;
import java.text.DecimalFormat;
import java.math.*;

import controller.WordDetails;

public class Filereader {

public static void main(String args[]){
	int count_weight = 50;		//Weight of number of words in deciding category
	int frequency_weight = 50;	//Weight of frequency of words in deciding category
	String file_name = "1.txt"; //Name of file to be read
try
{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection ("jdbc:mysql://localhost/test", "root", "");
	Statement stmt = conn.createStatement();
	ResultSet r = stmt.executeQuery("SELECT * FROM word_list");
	
	HashMap<String,WordDetails> hm=new HashMap<String,WordDetails>();    
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
	
	FileReader f1=new FileReader(file_name);
	BufferedReader b1=new BufferedReader(f1);
	String s1;
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
	while((s1=b1.readLine())!=null)
	{
		String s = s1.toLowerCase();
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
				if(wd.cnt > 0)
				{
					//System.out.println(m.getKey()+" : Category_ID = "+wd.cat_id+" : Word_Count = "+wd.cnt);
					tmp_id = wd.cat_id;
					w_cnt = word_cnt.get(tmp_id);
					f_cnt = freq_cnt.get(tmp_id);
					w_cnt += 1;
					f_cnt += wd.cnt;
					word_cnt.put(tmp_id,w_cnt);
					freq_cnt.put(tmp_id,f_cnt);
				}
			}
		}
	}
	int max_id = 0;
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
	System.out.println("The article belongs to category: " + category.get(max_id));
	
	DecimalFormat df = new DecimalFormat("#.##");
	df.setRoundingMode(RoundingMode.CEILING);
	Double percent;
	for(Map.Entry m:score.entrySet())
	{
		tmp_id = (Integer)m.getKey();
		tmp_score = (Integer)m.getValue();
		if(total_score != 0)
			percent = ((double)tmp_score/(double)total_score)*100;
		else
			percent = 0.00;
		System.out.println(category.get(tmp_id) + " : " + df.format(percent) + " %");
	}
	b1.close();
}
catch(Exception e)
{
	System.out.println(e);
}
}
}