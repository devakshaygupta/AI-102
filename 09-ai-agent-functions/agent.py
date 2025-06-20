import os
from pathlib import Path
from dotenv import load_dotenv

from azure.identity import DefaultAzureCredential
from azure.ai.agents import AgentsClient
from azure.ai.agents.models import FunctionTool, ToolSet, ListSortOrder, MessageRole
from user_functions import user_functions


def main():

    try:
        # Clear the console
        os.system('cls' if os.name == 'nt' else 'clear')

        # Load environment variables from .env file
        load_dotenv()

        PROJECT_ENDPOINT = os.getenv("PROJECT_ENDPOINT")
        MODEL_DEPLOYMENT_NAME = os.getenv("MODEL_DEPLOYMENT_NAME")

        # Connect to the Agent client
        agent_client = AgentsClient(
            endpoint=PROJECT_ENDPOINT,
            credential=DefaultAzureCredential
            (exclude_environment_credential=True,
            exclude_managed_identity_credential=True)
        )
        with agent_client:
            # Check if agent already exists
            agent_name = "support-agent"
            existing_agent = None
            agents = agent_client.list_agents()
            for ag in agents:
                if ag.name == agent_name:
                    existing_agent = ag
                    print(f"Using existing agent: {ag.id}")
                    break

            if existing_agent:
                agent = existing_agent
            else:
                # Define an agent that uses function
                functions = FunctionTool(user_functions)
                toolset = ToolSet()
                toolset.add(functions)
                agent_client.enable_auto_function_calls(toolset)

                agent = agent_client.create_agent(
                    model=MODEL_DEPLOYMENT_NAME,
                    name=agent_name,
                    instructions="""You are a technical support agent.
                                    When a user has a technical issue, you get their email address and a description of the issue.
                                    Then you use those values to submit a support ticket using the function available to you.
                                    If a file is saved, tell the user the file name.
                                  """,
                    toolset=toolset,
                    description="A support agent that can create support tickets using a function."
                )
                print(f"Created new agent: {agent.id}")

            # Create a thread for the conversation
            thread = agent_client.threads.create()

            while True:
                # Get input text
                user_prompt = input("Enter a prompt (or type 'quit' to exit): ")
                if user_prompt.lower() == "quit":
                    break
                if len(user_prompt) == 0:
                    print("Please enter a prompt.")
                    continue

                # Send a prompt to the agent
                message = agent_client.messages.create(
                    thread_id=thread.id,
                    role="user",
                    content=user_prompt
                )

                run = agent_client.runs.create_and_process(
                    thread_id=thread.id,
                    agent_id=agent.id,
                )

                # Check the run status for failures
                if run.status == "failed":
                    print(f"Run failed: {run.last_error}")

                # Get the response from the agent
                last_msg = agent_client.messages.get_last_message_text_by_role(
                    thread_id=thread.id,
                    role=MessageRole.AGENT
                )

                if last_msg:
                    print(f"Last Message: {last_msg.text.value}")

        # Get the conversation history
        print("\nConversation Log:\n")
        messages = agent_client.messages.list(thread_id=thread.id, order=ListSortOrder.ASCENDING)
        for message in messages:
            if message.text_messages:
                last_msg = message.text_messages[-1]
                print(f"{message.role}: {last_msg.text.value}\n")

        # Get any generated files
        for msg in messages:
            # Save every image file in the message
            for img in msg.image_contents:
                file_id = img.image_file.file_id
                file_name = f"{file_id}_image_file.png"
                agent_client.files.save(file_id=file_id, file_name=file_name)
                print(f"Saved image file to: {Path.cwd() / file_name}")

        agent_client.delete_agent(agent.id)

    except Exception as ex:
        print(ex)

if __name__ == "__main__":
    main()
