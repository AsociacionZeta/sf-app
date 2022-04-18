public without sharing class EmailSender {
	public static final String NO_REPLY_ADDRESS = 'No Reply';
	private static final List<String> VALID_ORG_EMAILS = new List<String>{ NO_REPLY_ADDRESS };
	public static Map<String, OrgWideEmailAddress> orgWideAddressByName;
	private List<Messaging.SingleEmailMessage> emailsToSend;

	public EmailSender() {
		if (orgWideAddressByName == null) {
			orgWideAddressByName = new Map<String, OrgWideEmailAddress>();
			List<OrgWideEmailAddress> orgWideAddresses = [Select Id, DisplayName, Address
			                                              from OrgWideEmailAddress];
			for (OrgWideEmailAddress orgAddress : orgWideAddresses) {
				if (VALID_ORG_EMAILS.contains(orgAddress.DisplayName)) {
					orgWideAddressByName.put(orgAddress.DisplayName, orgAddress);
				}
			}
		}
		emailsToSend = new List<Messaging.SingleEmailMessage>();
	}

	public void addEmail(Messaging.SingleEmailMessage email) {
		emailsToSend.add(email);
	}

	public static EmailBuilder createEmailBuilder() {
		return new EmailBuilder(null, null, null);
	}

	public static EmailBuilder createEmailBuilder(String templateId) {
		return new EmailBuilder(templateId);
	}

	public static EmailBuilder createEmailBuilder(String subject, String plainTextBody, String htmlBody) {
		return new EmailBuilder(subject, plainTextBody, htmlBody);
	}

	public Messaging.SendEmailResult[] send() {
		Messaging.SendEmailResult[] results;
		if (emailsToSend.size() > 0) {
			results = Messaging.sendEmail(emailsToSend);
			emailsToSend.clear();
		}
		return results;
	}

	public class EmailBuilder {
		private String subject;
		private String plainTextBody;
		private String htmlBody;
		private Set<String> toAddresses;
		private Set<String> ccAddresses;
		private Set<String> bccAddresses;
		private String templateId;
		private String recordId;
		private String whatId;
		private String whoId;
		private String replyTo;
		private Boolean useNoReplyAddress;
		private String customSenderName;
		private Map<String, String> replacements;
		private List<Messaging.EmailFileAttachment> attachments;

		public EmailBuilder() {
			this.toAddresses = new Set<String>();
			this.ccAddresses = new Set<String>();
			this.bccAddresses = new Set<String>();
			this.replacements = new Map<String, String>();
			this.attachments = new List<Messaging.EmailFileAttachment>();
		}

		public EmailBuilder(String templateId) {
			this();
			this.templateId = templateId;
		}

		public EmailBuilder(String subject, String plainTextBody, String htmlBody) {
			this();
			this.subject = subject;
			this.plainTextBody = plainTextBody;
			this.htmlBody = htmlBody;
		}

		public Messaging.SingleEmailMessage build() {
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			if (this.templateId != null) {
				if (Test.isRunningTest()) {
					email.setHtmlBody('body');
				} else {
					String whoId = this.whoId;
					String whatId = (this.recordId != null) ? this.recordId : this.whatId;
					SObjectType objectType = SchemaUtils.getSObjectTypeFromId(whatId);
					if (objectType == Contact.SObjectType || objectType == Lead.SObjectType || objectType == User.SObjectType) {
						whoId = whatId;
						whatId = null;
						email.setWhatId(null);
					}
					email = Messaging.renderStoredEmailTemplate(this.templateId, whoId, whatId);
				}
			} else {
				email.setPlainTextBody(this.plainTextBody);
				email.setHtmlBody(this.htmlBody);
				email.setSubject(this.subject);
			}
			if (this.attachments != null && this.attachments.size() > 0)
				email.setFileAttachments(this.attachments);
			email.setToAddresses(new List<String>(this.toAddresses));
			email.setCcAddresses(new List<String>(this.ccAddresses));
			email.setBccAddresses(new List<String>(this.bccAddresses));
			if (this.replyTo != null)
				email.setReplyTo(this.replyTo);
			if (this.customSenderName != null)
				email.setSenderDisplayName(this.customSenderName);
			if (this.useNoReplyAddress)
				email.setOrgWideEmailAddressId(EmailSender.orgWideAddressByName.get(EmailSender.NO_REPLY_ADDRESS).Id);
			return replace(email);
		}

		public EmailBuilder subject(String subject) {
			this.subject = subject;
			return this;
		}

		public EmailBuilder plainTextBody(String plainTextBody) {
			this.plainTextBody = plainTextBody;
			return this;
		}

		public EmailBuilder addToAddress(String toAddress) {
			toAddresses.add(toAddress);
			return this;
		}

		public EmailBuilder addToAddress(List<String> toAddresses) {
			toAddresses.addAll(toAddresses);
			return this;
		}

		public EmailBuilder addToAddress(Set<String> toAddresses) {
			toAddresses.addAll(toAddresses);
			return this;
		}

		public EmailBuilder addCcAddress(String ccAddress) {
			toAddresses.add(ccAddress);
			return this;
		}

		public EmailBuilder addCcAddress(List<String> ccAddresses) {
			toAddresses.addAll(ccAddresses);
			return this;
		}

		public EmailBuilder addCcAddress(Set<String> ccAddresses) {
			toAddresses.addAll(ccAddresses);
			return this;
		}

		public EmailBuilder addBccAddress(String bccAddress) {
			toAddresses.add(bccAddress);
			return this;
		}

		public EmailBuilder addBccAddress(List<String> bccAddresses) {
			toAddresses.addAll(bccAddresses);
			return this;
		}

		public EmailBuilder addBccAddress(Set<String> bccAddresses) {
			toAddresses.addAll(bccAddresses);
			return this;
		}

		public EmailBuilder addAttachment(Attachment attach) {
			if (attach != null) {
				Messaging.EmailFileAttachment emailWithAttch = new Messaging.EmailFileAttachment();
				emailWithAttch.setContentType(attach.ContentType);
				emailWithAttch.setBody(attach.Body);
				emailWithAttch.setFileName(attach.Name);
				emailWithAttch.setInline(false);
				this.attachments.add(emailWithAttch);
			}
			return this;
		}

		public EmailBuilder addAttachment(Attachment attach, Boolean inLine) {
			if (attach != null) {
				Messaging.EmailFileAttachment emailWithAttch = new Messaging.EmailFileAttachment();
				emailWithAttch.setContentType(attach.ContentType);
				emailWithAttch.setBody(attach.Body);
				emailWithAttch.setFileName(attach.Name);
				emailWithAttch.setInline(inLine);
				this.attachments.add(emailWithAttch);
			}
			return this;
		}

		public EmailBuilder addAttachment(String fileName, String body) {
			Messaging.EmailFileAttachment emailWithAttch = new Messaging.EmailFileAttachment();
			emailWithAttch.setBody(Blob.valueOf(body));
			emailWithAttch.setFileName(fileName);
			this.attachments.add(emailWithAttch);
			return this;
		}

		public EmailBuilder addAttachment(String fileName, Blob body) {
			Messaging.EmailFileAttachment emailWithAttch = new Messaging.EmailFileAttachment();
			emailWithAttch.setBody(body);
			emailWithAttch.setFileName(fileName);
			this.attachments.add(emailWithAttch);
			return this;
		}

		public EmailBuilder addAttachment(String fileName, String contentType, Blob body, Boolean inLine) {
			Messaging.EmailFileAttachment emailWithAttch = new Messaging.EmailFileAttachment();
			emailWithAttch.setContentType(contentType);
			emailWithAttch.setBody(body);
			emailWithAttch.setFileName(fileName);
			emailWithAttch.setInline(inLine);
			this.attachments.add(emailWithAttch);
			return this;
		}

		public EmailBuilder addAttachment(String fileName, String contentType, String body, Boolean inLine) {
			Messaging.EmailFileAttachment emailWithAttch = new Messaging.EmailFileAttachment();
			emailWithAttch.setContentType(contentType);
			emailWithAttch.setBody(Blob.valueOf(body));
			emailWithAttch.setFileName(fileName);
			emailWithAttch.setInline(inLine);
			this.attachments.add(emailWithAttch);
			return this;
		}

		public EmailBuilder htmlBody(String htmlBody) {
			this.htmlBody = htmlBody;
			return this;
		}

		public EmailBuilder templateId(String templateId) {
			this.templateId = templateId;
			return this;
		}

		public EmailBuilder recordId(String recordId) {
			this.recordId = recordId;
			return this;
		}

		public EmailBuilder whohId(String whoId) {
			this.whoId = whoId;
			return this;
		}

		public EmailBuilder whatId(String whatId) {
			this.whatId = whatId;
			return this;
		}

		public EmailBuilder replyTo(String replyTo) {
			this.replyTo = replyTo;
			return this;
		}

		public EmailBuilder useNoReplyAddress() {
			this.useNoReplyAddress = true;
			return this;
		}

		public EmailBuilder customSenderName(String customSenderName) {
			this.customSenderName = customSenderName;
			return this;
		}

		public EmailBuilder addReplacement(String key, String value) {
			this.replacements.put(key, value);
			return this;
		}

		private Messaging.SingleEmailMessage replace(Messaging.SingleEmailMessage email) {
			email.setPlainTextBody(replaceData(email.getPlainTextBody()));
			email.setHtmlBody(replaceData(email.getHtmlBody()));
			email.setSubject(replaceData(email.getSubject()));
			return email;
		}

		private String replaceData(String data) {
			if (data != null) {
				for (String key : replacements.keySet()) {
					data = data.replace('{' + key + '}', replacements.get(key));
				}
			}
			return data;
		}

	}

}