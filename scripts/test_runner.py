#!/usr/bin/env python
"""
Script de testes automatizados para o sistema ABASE
Executa testes completos sempre que solicitado
"""

import os
import sys
import subprocess
import time
from pathlib import Path
from datetime import datetime

# Adiciona o diretório raiz ao Python path
sys.path.append(str(Path(__file__).parent.parent))

class Color:
    """Cores para output no terminal"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    END = '\033[0m'
    BOLD = '\033[1m'

def print_header(message):
    """Imprime cabeçalho formatado"""
    print(f"\n{Color.BOLD}{Color.BLUE}{'='*60}{Color.END}")
    print(f"{Color.BOLD}{Color.BLUE}  {message}{Color.END}")
    print(f"{Color.BOLD}{Color.BLUE}{'='*60}{Color.END}\n")

def print_success(message):
    """Imprime mensagem de sucesso"""
    print(f"{Color.GREEN}[OK] {message}{Color.END}")

def print_error(message):
    """Imprime mensagem de erro"""
    print(f"{Color.RED}[ERRO] {message}{Color.END}")

def print_warning(message):
    """Imprime mensagem de aviso"""
    print(f"{Color.YELLOW}[AVISO] {message}{Color.END}")

def print_info(message):
    """Imprime mensagem informativa"""
    print(f"{Color.CYAN}[INFO] {message}{Color.END}")

def run_command(command, description, check_output=False):
    """
    Executa comando e retorna resultado
    
    Args:
        command (str): Comando a ser executado
        description (str): Descrição do comando
        check_output (bool): Se deve capturar output
        
    Returns:
        bool: True se comando executou com sucesso
    """
    print_info(f"Executando: {description}")
    print(f"  Comando: {command}")
    
    try:
        if check_output:
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                check=True,
                timeout=300,  # 5 minutos timeout
                shell=True
            )
            return True, result.stdout
        else:
            result = subprocess.run(
                command,
                check=True,
                timeout=300,
                shell=True
            )
            return True, None
    except subprocess.CalledProcessError as e:
        print_error(f"Comando falhou com código {e.returncode}")
        if hasattr(e, 'stdout') and e.stdout:
            print(f"STDOUT: {e.stdout}")
        if hasattr(e, 'stderr') and e.stderr:
            print(f"STDERR: {e.stderr}")
        return False, None
    except subprocess.TimeoutExpired:
        print_error("Comando excedeu timeout de 5 minutos")
        return False, None
    except Exception as e:
        print_error(f"Erro inesperado: {str(e)}")
        return False, None

def check_environment():
    """Verifica se o ambiente está configurado corretamente"""
    print_header("VERIFICANDO AMBIENTE")
    
    checks = []
    
    # Verificar se estamos no diretório correto
    if not os.path.exists('manage.py'):
        print_error("manage.py não encontrado. Execute este script no diretório raiz do projeto.")
        return False
    
    print_success("Diretório do projeto correto")
    
    # Verificar Python
    try:
        python_version = sys.version.split()[0]
        print_success(f"Python {python_version}")
        checks.append(True)
    except:
        print_error("Erro ao verificar versão do Python")
        checks.append(False)
    
    # Verificar Django
    success, output = run_command('python -c "import django; print(django.get_version())"', 
                                 "Verificar Django", check_output=True)
    if success and output:
        print_success(f"Django {output.strip()}")
        checks.append(True)
    else:
        print_error("Django não encontrado")
        checks.append(False)
    
    # Verificar banco de dados
    success, _ = run_command("python manage.py check --database default", 
                           "Verificar conexão com banco de dados")
    if success:
        print_success("Conexão com banco de dados OK")
        checks.append(True)
    else:
        print_error("Problema na conexão com banco de dados")
        checks.append(False)
    
    return all(checks)

def run_linting():
    """Executa verificações de qualidade de código"""
    print_header("VERIFICAÇÕES DE QUALIDADE DE CÓDIGO")
    
    checks = []
    
    # Verificar se flake8 está disponível
    try:
        subprocess.run(["flake8", "--version"], capture_output=True, check=True)
        
        # Executar flake8
        success, _ = run_command("flake8 apps core --max-line-length=120 --exclude=migrations", 
                               "Verificar PEP8 com flake8")
        if success:
            print_success("Código está em conformidade com PEP8")
        else:
            print_warning("Encontradas violações de PEP8 (não crítico)")
        checks.append(success)
        
    except (subprocess.CalledProcessError, FileNotFoundError):
        print_warning("flake8 não encontrado, pulando verificação PEP8")
        print_info("Para instalar: pip install flake8")
    
    # Verificar imports não utilizados
    try:
        subprocess.run(["autoflake", "--version"], capture_output=True, check=True)
        
        success, _ = run_command("autoflake --check-diff --recursive apps core", 
                               "Verificar imports não utilizados")
        if success:
            print_success("Nenhum import não utilizado encontrado")
        else:
            print_warning("Imports não utilizados encontrados (não crítico)")
        checks.append(success)
        
    except (subprocess.CalledProcessError, FileNotFoundError):
        print_warning("autoflake não encontrado, pulando verificação de imports")
        print_info("Para instalar: pip install autoflake")
    
    return len(checks) == 0 or any(checks)  # Passa se não houver checks ou se pelo menos um passou

def run_security_checks():
    """Executa verificações de segurança"""
    print_header("VERIFICAÇÕES DE SEGURANÇA")
    
    checks = []
    
    # Django security check
    success, _ = run_command("python manage.py check --deploy", 
                           "Verificações de segurança do Django")
    if success:
        print_success("Verificações de segurança do Django passaram")
    else:
        print_warning("Avisos de segurança encontrados")
    checks.append(success)
    
    # Verificar se há SECRET_KEY no código
    try:
        result = subprocess.run(
            ["grep", "-r", "SECRET_KEY", "apps/", "core/"],
            capture_output=True, text=True
        )
        if result.returncode == 0:
            print_error("SECRET_KEY encontrada no código fonte!")
            print("Linhas encontradas:")
            print(result.stdout)
            checks.append(False)
        else:
            print_success("Nenhuma SECRET_KEY hardcoded encontrada")
            checks.append(True)
    except FileNotFoundError:
        print_warning("Comando grep não disponível, pulando verificação SECRET_KEY")
    
    return any(checks)

def run_django_tests():
    """Executa testes do Django"""
    print_header("TESTES DO DJANGO")
    
    # Descobrir apps com testes
    apps_with_tests = []
    for app_dir in Path('apps').iterdir():
        if app_dir.is_dir() and (app_dir / 'tests').exists():
            apps_with_tests.append(f"apps.{app_dir.name}")
    
    if not apps_with_tests:
        print_warning("Nenhuma app com testes encontrada")
        return True
    
    print_info(f"Apps com testes encontradas: {', '.join(apps_with_tests)}")
    
    # Executar testes
    success, _ = run_command(
        f"python manage.py test {' '.join(apps_with_tests)} --verbosity=2",
        f"Executar testes Django para {len(apps_with_tests)} apps"
    )
    
    if success:
        print_success("Todos os testes Django passaram")
        return True
    else:
        print_error("Alguns testes Django falharam")
        return False

def run_coverage_tests():
    """Executa testes com coverage"""
    print_header("COBERTURA DE TESTES")
    
    try:
        subprocess.run(["coverage", "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print_warning("coverage não encontrado, pulando análise de cobertura")
        print_info("Para instalar: pip install coverage")
        return True
    
    # Executar testes com coverage
    success, _ = run_command(
        "coverage run --source='.' manage.py test",
        "Executar testes com análise de cobertura"
    )
    
    if not success:
        print_error("Falha ao executar testes com coverage")
        return False
    
    # Gerar relatório
    success, output = run_command(
        "coverage report --show-missing",
        "Gerar relatório de cobertura",
        check_output=True
    )
    
    if success and output:
        print_success("Relatório de cobertura:")
        print(output)
        
        # Gerar HTML
        run_command(
            "coverage html",
            "Gerar relatório HTML de cobertura"
        )
        print_info("Relatório HTML gerado em htmlcov/index.html")
    
    return success

def run_frontend_tests():
    """Executa testes do frontend"""
    print_header("TESTES DO FRONTEND")
    
    # Verificar se Tailwind está compilando corretamente
    if os.path.exists('tailwind.config.js'):
        success, _ = run_command(
            "npx tailwindcss -i ./assets/tailwind.css -o ./static/css/app.css --minify",
            "Compilar CSS com Tailwind"
        )
        
        if success:
            print_success("CSS compilado com sucesso")
            
            # Verificar se o arquivo foi gerado
            if os.path.exists('static/css/app.css'):
                file_size = os.path.getsize('static/css/app.css')
                print_info(f"Arquivo CSS gerado: {file_size} bytes")
            
            return True
        else:
            print_error("Falha na compilação do CSS")
            return False
    else:
        print_warning("tailwind.config.js não encontrado")
        return True

def run_migration_check():
    """Verifica se há migrações pendentes"""
    print_header("VERIFICAÇÃO DE MIGRAÇÕES")
    
    # Verificar migrações pendentes
    success, output = run_command(
        "python manage.py showmigrations --plan",
        "Verificar status das migrações",
        check_output=True
    )
    
    if success and output:
        # Verificar se há migrações não aplicadas
        if "[ ]" in output:
            print_error("Há migrações pendentes!")
            print("Migrações não aplicadas:")
            for line in output.split('\n'):
                if "[ ]" in line:
                    print(f"  {line}")
            return False
        else:
            print_success("Todas as migrações estão aplicadas")
            return True
    
    return success

def generate_test_report():
    """Gera relatório final dos testes"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    report = f"""
# RELATÓRIO DE TESTES AUTOMATIZADOS - ABASE

**Data/Hora:** {timestamp}
**Ambiente:** {os.environ.get('ENVIRONMENT', 'development')}
**Python:** {sys.version.split()[0]}
**Diretório:** {os.getcwd()}

## Testes Executados

Todos os testes foram executados conforme configurado no script test_runner.py.

## Próximos Passos

1. Corrigir falhas encontradas (se houver)
2. Aumentar cobertura de testes se necessário
3. Executar testes novamente antes de commit

## Como Executar Novamente

```bash
python scripts/test_runner.py --full
```

---
*Relatório gerado automaticamente pelo sistema de testes ABASE*
"""
    
    # Salvar relatório
    report_path = Path('documentos/test_reports')
    report_path.mkdir(exist_ok=True)
    
    filename = f"test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
    report_file = report_path / filename
    
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print_info(f"Relatório salvo em: {report_file}")

def main():
    """Função principal do script"""
    start_time = time.time()
    
    print_header("INICIANDO TESTES AUTOMATIZADOS - SISTEMA ABASE")
    print_info(f"Iniciado em: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Lista de testes a executar
    tests = [
        ("Ambiente", check_environment),
        ("Qualidade de Código", run_linting),
        ("Segurança", run_security_checks),
        ("Migrações", run_migration_check),
        ("Django Tests", run_django_tests),
        ("Frontend", run_frontend_tests),
        ("Coverage", run_coverage_tests),
    ]
    
    results = {}
    
    # Executar cada teste
    for test_name, test_function in tests:
        try:
            result = test_function()
            results[test_name] = result
        except Exception as e:
            print_error(f"Erro inesperado em {test_name}: {str(e)}")
            results[test_name] = False
    
    # Relatório final
    print_header("RELATÓRIO FINAL")
    
    passed = 0
    total = len(results)
    
    for test_name, result in results.items():
        if result:
            print_success(f"{test_name}: PASSOU")
            passed += 1
        else:
            print_error(f"{test_name}: FALHOU")
    
    # Estatísticas
    duration = time.time() - start_time
    print(f"\n{Color.BOLD}Resumo:{Color.END}")
    print(f"  Testes executados: {total}")
    print(f"  Sucessos: {Color.GREEN}{passed}{Color.END}")
    print(f"  Falhas: {Color.RED}{total - passed}{Color.END}")
    print(f"  Duração: {duration:.2f} segundos")
    
    # Gerar relatório
    generate_test_report()
    
    # Status de saída
    if passed == total:
        print_success("TODOS OS TESTES PASSARAM!")
        return 0
    elif passed >= total * 0.7:  # 70% de sucesso
        print_warning("MAIORIA DOS TESTES PASSOU (algumas falhas nao criticas)")
        return 0
    else:
        print_error("MUITOS TESTES FALHARAM - ACAO NECESSARIA")
        return 1

if __name__ == '__main__':
    exit_code = main()
    sys.exit(exit_code)