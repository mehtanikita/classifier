package controller;

import com.semantria.mapping.Document;
import com.semantria.mapping.output.*;
import com.semantria.serializer.JsonSerializer;
import com.semantria.*;
import org.apache.commons.lang3.StringUtils;

import java.io.*;
import java.util.*;

public class Sentiment {
	private static final int TIMEOUT_BEFORE_GETTING_RESPONSE = 1;
	private final String key = "348942b3-e0ee-429c-8eb2-7441c62056ba";
	private final String secret = "43e705f6-b95b-4ee4-ac9f-cdb9a56335d4";
	
	public String type;
	public String score;
	
	public Sentiment(String text)
	{
		Hashtable<String, TaskStatus> docsTracker = new Hashtable<String, TaskStatus>();
		List<String> initialTexts = new ArrayList<String>();
		
		String strLine = text;
		initialTexts.add(strLine);
		
		// Initializes new session with the serializer object and the keys.
		Session session = Session.createSession(key, secret);
        session.registerSerializer(new JsonSerializer());
		session.setCallbackHandler(new CallbackHandler());

        //Obtaining subscription object to get user limits applicable on server side
        Subscription subscription = session.getSubscription();

        List<Document> outgoingBatch = new ArrayList<Document>(subscription.getBasicSettings().getIncomingBatchLimit());

        for(Iterator<String> iterator = initialTexts.iterator(); iterator.hasNext(); ) {
            String uid = UUID.randomUUID().toString();
            Document doc = new Document(uid, iterator.next());
            outgoingBatch.add(doc);
            docsTracker.put(uid, TaskStatus.QUEUED);

            if (outgoingBatch.size() == subscription.getBasicSettings().getIncomingBatchLimit()) {
                if(session.QueueBatchOfDocuments(outgoingBatch, null) == 202) {
                    outgoingBatch.clear();
                }
            }
        }

        if (outgoingBatch.size() > 0)
        {
            if( session.QueueBatchOfDocuments(outgoingBatch, null) == 202) {
                outgoingBatch.clear();
            }
        }
		try
		{
			List<DocAnalyticData> processed = new ArrayList<DocAnalyticData>();
			
			while(docsTracker.containsValue(TaskStatus.QUEUED))
			{
                Thread.currentThread().sleep(TIMEOUT_BEFORE_GETTING_RESPONSE);

				List<DocAnalyticData> temp = session.getProcessedDocuments(null);
                for(Iterator<DocAnalyticData> i = temp.iterator(); i.hasNext(); ) {
                    DocAnalyticData item = i.next();

                    if (docsTracker.containsKey(item.getId())) {
                        processed.add(item);
                        docsTracker.put(item.getId(), TaskStatus.PROCESSED);
                        break;
                    }
                }
			}

			// Output results
			for(DocAnalyticData doc : processed)
			{
				this.type = doc.getSentimentPolarity();
				this.score = Float.toString(doc.getSentimentScore());
				break;
			}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
	}
}
