package model;

/**
 * Model đại diện cho một quy tắc trả lời của Chatbot.
 * Ánh xạ tới bảng ChatbotRule trong cơ sở dữ liệu.
 */
public class ChatbotRule {
    private int ruleID;
    private String keywords;
    private String reply;

    public ChatbotRule() {
    }

    public ChatbotRule(int ruleID, String keywords, String reply) {
        this.ruleID = ruleID;
        this.keywords = keywords;
        this.reply = reply;
    }

    public int getRuleID() {
        return ruleID;
    }

    public void setRuleID(int ruleID) {
        this.ruleID = ruleID;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }
}
