from dotenv import load_dotenv
import os

# Import namespaces
from azure.core.credentials import AzureKeyCredential
from azure.ai.language.questionanswering import QuestionAnsweringClient


def main():
    try:
        # Get Configuration Settings
        load_dotenv()
        ai_endpoint = os.getenv('AI_SERVICE_ENDPOINT')
        ai_key = os.getenv('AI_SERVICE_KEY')
        ai_project_name = os.getenv('QA_PROJECT_NAME')
        ai_deployment_name = os.getenv('QA_DEPLOYMENT_NAME')

        # Create client using endpoint and key
        qna_client = QuestionAnsweringClient(
            credential=AzureKeyCredential(ai_key),
            endpoint=ai_endpoint
        )

        # Submit a question and display the answer
        user_question = ''
        while True:
            user_question = input('\nQuestion:\n')
            if user_question.lower() == "quit":
                break
            response = qna_client.get_answers(question=user_question,
                                              project_name=ai_project_name,
                                              deployment_name=ai_deployment_name)
            for candidate in response.answers:
                print(candidate.answer)
                print(f"Confidence: {candidate.confidence}")
                print(f"Source: {candidate.source}")

    except Exception as ex:
        print(ex)


if __name__ == "__main__":
    main()
