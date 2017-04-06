package controller;

public class ArticleDetails {
	
	public Integer id;
	public String title;
	public String name;
	public String abstr;
	public String r_score;
	public String[] tags;
	public String time_when;
	
	public ArticleDetails(Integer id,String title, String name, String abstr, String r_score, String[] tags, String time_when)
	{
		this.id = id;
		this.title = title;
		this.name = name;
		this.abstr = abstr;
		this.r_score = r_score;
		this.tags = tags;
		this.time_when = time_when;
	}
	public String pr()
	{
		return this.id + ", " + this.id + ", " + this.title + ", " + this.name + ", " + this.r_score;
	}
}
