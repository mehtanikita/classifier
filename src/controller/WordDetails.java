package controller;

public class WordDetails {

	public Integer word_id;
	public Integer cat_id;
	public Integer cnt;
	
	public WordDetails(Integer word_id, Integer cat_id, Integer cnt)
	{
		this.word_id = word_id;
		this.cat_id = cat_id;
		this.cnt = cnt;
	}
}
