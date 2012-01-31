#set( $symbol_pound  = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import java.io.*;

import org.antlr.runtime.*;

import sample.*;

public class Main {
	private static LanguageParser createStringParser(String input) {
		LanguageLexer lexer = new LanguageLexer(new ANTLRStringStream(input));
		CommonTokenStream tokens = new CommonTokenStream();
		tokens.setTokenSource(lexer);
		return new LanguageParser(tokens);
	}

	public static void main(String[] args) {
		try {
			BufferedReader console = new BufferedReader(new InputStreamReader(System.in));

			System.out.println("Enter 'quit' to stop.");
			while(true) {
				System.out.print(">>> ");
				System.out.flush();

				String input = console.readLine();
				if ("quit".equals(input))
					break;
				
				createStringParser(input).program();
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
